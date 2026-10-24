class_name Interactable
extends Area2D
## Interactable objects can use this class as interface
## to determine whether or now to show input hints
## and handle interaction logic.
##
## Improtant that double interactions are possible.
## This means placing 2 hints in different level versions
## may lead to problems.

signal hint_toggled(show: bool)
signal interacted

const INPUT_INTERACT: StringName = &"interact"

@export var single_use: bool = false

var _available: bool = false
var _used: bool = false


func _physics_process(_delta: float) -> void:
	if _used && single_use:
		_available = false
		return

	var new_value: bool = false
	for body: Node2D in get_overlapping_bodies():
		if body is Pchar:
			new_value = true
			break

	if new_value != _available:
		_available = new_value
		hint_toggled.emit(new_value)


func _unhandled_input(event: InputEvent) -> void:
	if !_available || event.is_echo():
		return
	if event.is_action_pressed(INPUT_INTERACT):
		_used = true
		interacted.emit()


func reset_usage() -> void:
	_used = false
