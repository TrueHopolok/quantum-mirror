class_name Player
extends Node2D

signal collected_gate(op: QuantumState.Gate)

## Same input map as [constant INPUT_MAP],
## but contains a debug inputs.
const DEBUG_INPUT_MAP: Dictionary[StringName, String] = {
	&"debug_quantum_observation": "handle_observation",
	&"debug_quantum_infinity": "handle_infinity",
}

## Input map that for each input action
## stores a method name, which will be executed on such input.
const INPUT_MAP: Dictionary[StringName, String] = {
	&"quantum_x": "handle_gate_x",
	&"quantum_z": "handle_gate_z",
	&"quantum_h": "handle_gate_h",
	&"quantum_inverse": "handle_inverse",
	&"restart_level": "handle_death",
}

@export var state: QuantumState

@export_group("Gate Usages")
@export_subgroup("X Gate", "x_gate")
## How many X gate uses are left for player to use
@export var x_gate_uses: int = 0
## Allows infinite uses of the X gates, ignoring usage count
@export var x_gate_infinite: bool = false

@export_subgroup("Z Gate", "z_gate")
## How many X gate uses are left for player to use
@export var z_gate_uses: int = 0
## Allows infinite uses of the X gates, ignoring usage count
@export var z_gate_infinite: bool = false

@export_subgroup("H Gate", "h_gate")
## How many X gate uses are left for player to use
@export var h_gate_uses: int = 0
## Allows infinite uses of the X gates, ignoring usage count
@export var h_gate_infinite: bool = false

@onready var _upper_pchar: Pchar = %UpperPchar
@onready var _lower_pchar: Pchar = %LowerPchar
@onready var _upper_spawn: SpawnArea = %UpperSpawn
@onready var _lower_spawn: SpawnArea = %LowerSpawn


func _ready() -> void:
	assert(
		global_position.y == 0 || global_position.y == 190,
		"Player._ready(): global_position is bad"
	)

	if !is_instance_valid(state):
		printerr("Player._ready(): quantum state is nil")
		state = QuantumState.new()

	if !state.split:
		if state.inverse:
			_upper_pchar.disable_self()
		else:
			_lower_pchar.disable_self()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if OS.is_debug_build():
		for input: StringName in DEBUG_INPUT_MAP:
			if !event.is_action_pressed(input):
				continue
			Callable(self, DEBUG_INPUT_MAP[input]).call()

	for input: StringName in INPUT_MAP:
		if !event.is_action_pressed(input):
			continue
		Callable(self, INPUT_MAP[input]).call()


func handle_gate_x() -> void:
	if !x_gate_infinite && x_gate_uses <= 0:
		return

	if !state.check_gate(QuantumState.Gate.X):
		return

	# From |1> to |0>
	if state.inverse:
		# X gate into the wall check
		if _upper_spawn.has_overlapping_bodies():
			return
		_upper_pchar.enable_self(_upper_spawn.global_position, _lower_pchar)
		_lower_pchar.disable_self()

	# From |0> to |1>
	else:
		# X gate into the wall check
		if _lower_spawn.has_overlapping_bodies():
			return
		_lower_pchar.enable_self(_lower_spawn.global_position, _upper_pchar)
		_upper_pchar.disable_self()

	x_gate_uses -= 1
	state.apply_gate(QuantumState.Gate.X)


func handle_gate_z() -> void:
	if !z_gate_infinite && z_gate_uses <= 0:
		return

	if !state.check_gate(QuantumState.Gate.Z):
		return

	z_gate_uses -= 1
	state.apply_gate(QuantumState.Gate.Z)


func handle_gate_h() -> void:
	if !h_gate_infinite && h_gate_uses <= 0:
		return

	if !state.check_gate(QuantumState.Gate.H):
		return

	if state.split:
		# From |-> to |1>
		if state.inverse:
			_upper_pchar.disable_self()

		# From |+> to |0>
		else:
			_lower_pchar.disable_self()

	else:
		# From |1> to |->
		if state.inverse:
			if _upper_spawn.has_overlapping_bodies():
				return
			_upper_pchar.enable_self(_upper_spawn.global_position, _lower_pchar)

		# From |0> to |+>
		else:
			if _lower_spawn.has_overlapping_bodies():
				return
			_lower_pchar.enable_self(_lower_spawn.global_position, _upper_pchar)

	h_gate_uses -= 1
	state.apply_gate(QuantumState.Gate.H)


func handle_inverse() -> void:
	if state.split:
		handle_gate_z()
	else:
		handle_gate_x()


func handle_observation() -> void:
	# Both checks and if okay, then applies
	if !state.apply_observation():
		return

	# From |-> or |+> to |1>
	if state.inverse:
		_upper_pchar.disable_self()

	# From |-> or |+> to |0>
	else:
		_lower_pchar.disable_self()


## Ignores observation and directly kills player
func handle_death() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	# TODO: add death animation and after short delay execute following
	Transition.reload_scene()


func handle_infinity() -> void:
	x_gate_infinite = true
	z_gate_infinite = true
	h_gate_infinite = true
	state.observed.emit()


func collect_gate(op: QuantumState.Gate) -> void:
	match op:
		QuantumState.Gate.X:
			x_gate_uses += 1
		QuantumState.Gate.Z:
			z_gate_uses += 1
		QuantumState.Gate.H:
			h_gate_uses += 1
		_:
			printerr("collected gate with corrupted value")
	collected_gate.emit(op)
