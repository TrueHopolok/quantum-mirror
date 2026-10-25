class_name Exit
extends Node2D

enum ExitRequirement {
	BOTH,
	ONLY_UP,
	ONLY_LOW,
}

@export var _requirement: ExitRequirement = ExitRequirement.BOTH
@export_file("*.tscn") var _next_scene: String
@export var _level_num: int = 0  # zero is a test level

@onready var _upper_door: ExitDoor = %UpperDoor
@onready var _lower_door: ExitDoor = %LowerDoor


func _ready() -> void:
	assert(FileAccess.file_exists(_next_scene), "Exit._ready(): next_scene does not exists")
	if _level_num <= 0:
		printerr("Level number is INVALID: This level is a test")
	else:
		Persistence.submit(Persistence.ROW_REACHED, _level_num)
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
		if _level_num > 0:
			Persistence.submit(Persistence.ROW_COMPLETED, _level_num)
		Transition.change_scene_path(_next_scene)
