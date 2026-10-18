class_name Collectable
extends Area2D

signal collected(player: Player)


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if !is_instance_of(body, Pchar):
		return
	set_deferred(&"monitoring", false)
	collected.emit(body.get_parent())
