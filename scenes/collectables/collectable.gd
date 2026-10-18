class_name Collectable
extends Area2D

signal collected


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if !is_instance_of(body, Pchar):
		return
	monitoring = false
	collected.emit()
