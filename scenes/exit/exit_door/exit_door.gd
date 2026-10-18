class_name ExitDoor
extends Area2D

@onready var _collider: CollisionShape2D = $DetectionCollider


func player_is_ready() -> bool:
	for body: Node2D in get_overlapping_bodies():
		if body is Pchar:
			return true
	return false


func disable_collider() -> void:
	_collider.set_deferred(&"disabled", true)
