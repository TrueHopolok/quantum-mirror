class_name SpawnArea
extends Area2D

@export var _player_root: Player
@export var _following_pchar: Pchar
@export var _spawning_pchar: Pchar

@onready var _sprite: AnimatedSprite2D = %WarningSprite


func _physics_process(_delta: float) -> void:
	global_position = Vector2(
		_following_pchar.global_position.x,
		-_following_pchar.global_position.y + _player_root.global_position.y * 2
	)
	if !_spawning_pchar.can_process():
		_spawning_pchar.global_position = global_position
		_sprite.show()
		_sprite.modulate = Color.RED if has_overlapping_bodies() else Color.WHITE
	else:
		_sprite.hide()
