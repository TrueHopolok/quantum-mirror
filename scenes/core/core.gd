class_name Core
extends Area2D

@export_file("*.tscn") var _next_scene: String
@export var _level_num: int = 0  # zero is a test level


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if !is_instance_of(body, Pchar):
		return
	if _level_num > 0:
		Persistence.submit(Persistence.ROW_COMPLETED, _level_num)
	Transition.change_scene_path(_next_scene)
