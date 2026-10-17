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
		if !event.is_action_pressed(input) && event.is_echo():
			continue
		Callable(self, INPUT_MAP[input]).call()


## Does nothing for now, but will do everything
func handle() -> void:
	pass
