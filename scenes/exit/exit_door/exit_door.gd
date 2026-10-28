class_name ExitDoor
extends Area2D

@onready var _collider: CollisionShape2D = %DetectionCollider
@onready var _sprite: ColorRect = %DoorSprite


func player_is_ready() -> Player:
	for body: Node2D in get_overlapping_bodies():
		if body is Pchar:
			return (body as Pchar).get_root()
	return null


func disable_collider(skip_animation: bool = false) -> void:
	_collider.set_deferred(&"disabled", true)
	if skip_animation:
		_sprite.hide()
	else:
		_sprite.hide()  # TODO: start animation
