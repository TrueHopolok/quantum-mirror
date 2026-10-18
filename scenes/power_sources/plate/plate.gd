class_name Plate
extends PowerSource

@onready var _detection_area: Area2D = %DetectionArea


func _physics_process(_delta: float) -> void:
	var new_value: bool = false
	for body: Node2D in _detection_area.get_overlapping_bodies():
		if body is Pchar:
			new_value = true
			break
	if new_value != powered:
		toggle_power()
