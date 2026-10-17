class_name SpawnArea
extends Area2D

var _pchar: Pchar


func _ready() -> void:
	_pchar = get_parent() as Pchar


func _physics_process(_delta: float) -> void:
	global_position = Vector2(_pchar.global_position.x, -_pchar.global_position.y)
