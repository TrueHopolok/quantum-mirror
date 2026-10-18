class_name Player
extends Node2D

## Input map that for each input action
## stores a method name, which will be executed on such input.
const INPUT_MAP: Dictionary[StringName, String] = {
	&"quantum_x": "handle_gate_x",
	&"quantum_z": "handle_gate_z",
	&"quantum_h": "handle_gate_h",
	&"quantum_inverse": "handle_inverse",
}

@export var _state: QuantumState

@onready var _upper_pchar: Pchar = %UpperPchar
@onready var _lower_pchar: Pchar = %LowerPchar


func _ready() -> void:
	if !is_instance_valid(_state):
		printerr("Player._ready(): quantum state is nil")
		_state = QuantumState.new()

	if !_state.split:
		if _state.inverse:
			_upper_pchar.disable_self()
		else:
			_lower_pchar.disable_self()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if OS.is_debug_build():
		if event.is_action_pressed(&"debug_quantum_observation"):
			handle_observation()

	for input: StringName in INPUT_MAP:
		if !event.is_action_pressed(input):
			continue
		Callable(self, INPUT_MAP[input]).call()


func handle_gate_x() -> void:
	if !_state.check_gate(QuantumState.Gate.X):
		return

	# From |1> to |0>
	if _state.inverse:
		# X gate into the wall check
		if !_lower_pchar.can_mirror():
			return
		_upper_pchar.enable_self(_lower_pchar)
		_lower_pchar.disable_self()

	# From |0> to |1>
	else:
		# X gate into the wall check
		if !_upper_pchar.can_mirror():
			return
		_lower_pchar.enable_self(_upper_pchar)
		_upper_pchar.disable_self()

	_state.apply_gate(QuantumState.Gate.X)


func handle_gate_z() -> void:
	# Both checks and if okay, then applies
	if !_state.apply_gate(QuantumState.Gate.Z):
		return


func handle_gate_h() -> void:
	# Both checks and if okay, then applies
	if !_state.apply_gate(QuantumState.Gate.H):
		return

	if _state.split:
		# From |1> to |->
		if _state.inverse:
			_upper_pchar.enable_self(_lower_pchar)

		# From |0> to |+>
		else:
			_lower_pchar.enable_self(_upper_pchar)
	else:
		# From |-> to |1>
		if _state.inverse:
			_upper_pchar.disable_self()

		# From |+> to |0>
		else:
			_lower_pchar.disable_self()


func handle_inverse() -> void:
	if _state.split:
		handle_gate_z()
	else:
		handle_gate_x()


func handle_observation() -> void:
	# Both checks and if okay, then applies
	if !_state.apply_observation():
		return

	# From |-> or |+> to |1>
	if _state.inverse:
		_upper_pchar.disable_self()

	# From |-> or |+> to |0>
	else:
		_lower_pchar.disable_self()
