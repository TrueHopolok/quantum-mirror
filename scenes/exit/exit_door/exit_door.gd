class_name ExitDoor
extends Area2D

@onready var _collider: CollisionShape2D = %DetectionCollider
@onready var _sprite: AnimatedSprite2D = %DoorSprite


func player_is_ready() -> Player:
	for body: Node2D in get_overlapping_bodies():
		if !body is Pchar:
			continue
		var pbody: Pchar = body as Pchar
		if !_is_really_inside(pbody):
			continue
		return pbody.get_root()
	return null


func disable_collider() -> void:
	_collider.set_deferred(&"disabled", true)
	_sprite.frame = 1


func _is_really_inside(pbody: Pchar) -> bool:
	if pbody.collider.disabled || pbody.collider.shape == null:
		return false
	return pbody.collider.shape.collide(
		pbody.collider.global_transform, _collider.shape, _collider.global_transform
	)
