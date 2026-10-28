class_name Surveillance
extends Node2D

@export var _rotate_duration: float = 1
@export var _watch_duration: float = 0

var _rotating_left: float = 0

@onready var _watching_left: float = _watch_duration
@onready var _area: Area2D = %DetectionArea
@onready var _collider: CollisionShape2D = %DetectionCollider
@onready var _detection_sprite: ColorRect = %DetectionSprite


func _physics_process(delta: float) -> void:
	if _watch_duration > 0:
		if _rotating_left > 0:
			_rotating_left = clampf(_rotating_left - delta, 0, _rotate_duration)
			if _rotating_left <= 0:
				_watching_left = _watch_duration
				_collider.position.x = -_collider.position.x
				_collider.set_deferred(&"disabled", false)
				_detection_sprite.show()
				# TODO: set camera sprite to side value with flip_h if needed
				return  # skip this monitoring frame
		else:
			_watching_left = clampf(_watching_left - delta, 0, _watch_duration)
			if _watching_left <= 0:
				_rotating_left = _rotate_duration
				_collider.set_deferred(&"disabled", true)
				_detection_sprite.hide()
				# TODO: set camera sprite to middle value

	if _rotating_left > 0 || _collider.disabled:
		return

	for body: Node2D in _area.get_overlapping_bodies():
		var pbody: Pchar = body as Pchar
		if pbody == null or !pbody.can_process() or !_is_really_inside(pbody):
			continue

		var player: Player = pbody.get_root()
		if player.state.split:
			player.handle_observation()
		break


func _is_really_inside(pbody: Pchar) -> bool:
	if pbody.collider.disabled || pbody.collider.shape == null:
		return false
	return pbody.collider.shape.collide(
		pbody.collider.global_transform, _collider.shape, _collider.global_transform
	)
