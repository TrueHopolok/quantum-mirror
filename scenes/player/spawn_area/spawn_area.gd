class_name SpawnArea
extends Area2D

@export var _player_root: Player
@export var _following_pchar: Pchar
@export var _spawning_pchar: Pchar


func _physics_process(_delta: float) -> void:
	global_position = Vector2(
		_following_pchar.global_position.x,
		-_following_pchar.global_position.y + _player_root.global_position.y * 2
	)
	if !_spawning_pchar.can_process():
		_spawning_pchar.global_position = global_position
