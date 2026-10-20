class_name Exit
extends Node2D

enum ExitRequirement {
	BOTH,
	ONLY_UP,
	ONLY_LOW,
}

@export var _requirement: ExitRequirement = ExitRequirement.BOTH

@onready var _upper_door: ExitDoor = %UpperDoor
@onready var _lower_door: ExitDoor = %LowerDoor


func _ready() -> void:
	if _requirement == ExitRequirement.ONLY_LOW:
		_upper_door.disable_collider(true)
	elif _requirement == ExitRequirement.ONLY_UP:
		_lower_door.disable_collider(true)


func _physics_process(_delta: float) -> void:
	var exiting: bool = true
	if _requirement == ExitRequirement.ONLY_UP || _requirement == ExitRequirement.BOTH:
		exiting = exiting && _upper_door.player_is_ready()
	if _requirement == ExitRequirement.ONLY_LOW || _requirement == ExitRequirement.BOTH:
		exiting = exiting && _lower_door.player_is_ready()
	if exiting:
		_upper_door.disable_collider()
		_lower_door.disable_collider()
		print("WOW, player finished the level")
