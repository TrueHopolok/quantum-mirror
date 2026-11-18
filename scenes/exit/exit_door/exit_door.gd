class_name ExitDoor
extends Area2D

@onready var _collider: CollisionShape2D = %DetectionCollider
@onready var _sprite: AnimatedSprite2D = %DoorSprite


func player_is_ready() -> Player:
	for body: Node2D in get_overlapping_bodies():
		if body is Pchar:
			return (body as Pchar).get_root()
	return null


func disable_collider() -> void:
	_collider.set_deferred(&"disabled", true)
	_sprite.frame = 1
