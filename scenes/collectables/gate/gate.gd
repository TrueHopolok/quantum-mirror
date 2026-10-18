class_name CollectableGate
extends Collectable

@export var _value: QuantumState.Gate


func _ready() -> void:
	super()
	collected.connect(_on_collected)


func _on_collected(player: Player) -> void:
	player.collect_gate(_value)
	queue_free()
