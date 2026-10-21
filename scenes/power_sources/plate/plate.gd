class_name Plate
extends PowerSource

@onready var _detection_area: Area2D = %DetectionArea
@onready var _sprite: ColorRect = %PlateSprite


func _physics_process(_delta: float) -> void:
	var new_value: bool = false
	for body: Node2D in _detection_area.get_overlapping_bodies():
		if body is Pchar:
			new_value = true
			break
	if new_value != powered:
		toggle_power()
	# TODO: add different sprite for being toggled
	_sprite.color.r = 1.0 if powered else 0.5
	_sprite.color.g = 1.0 if powered else 0.5
