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
	for input: StringName in INPUT_MAP:
		if !event.is_action_pressed(input) || event.is_echo():
			continue
		Callable(self, INPUT_MAP[input]).call()


func handle_gate_x() -> void:
	if !_state.check_gate(QuantumState.Gate.X):
		return

	# From |1> to |0>
	if _state.inverse:
		if !_lower_pchar.can_mirror():
			print("blocked")
			return
		_upper_pchar.enable_self(_lower_pchar)
		_lower_pchar.disable_self()

	# From |0> to |1>
	else:
		if !_upper_pchar.can_mirror():
			print("blocked")
			return
		_lower_pchar.enable_self(_upper_pchar)
		_upper_pchar.disable_self()

	_state.apply_gate(QuantumState.Gate.X)


func handle_gate_z() -> void:
	pass


func handle_gate_h() -> void:
	pass


func handle_inverse() -> void:
	if _state.split:
		handle_gate_z()
	else:
		handle_gate_x()
