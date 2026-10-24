class_name CollectableGate
extends Area2D

@export var _value: QuantumState.Gate

@onready var _label: Label = %ValueLabel


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var symbol: String = "?"
	match _value:
		QuantumState.Gate.X:
			symbol = "X"
		QuantumState.Gate.Z:
			symbol = "Z"
		QuantumState.Gate.H:
			symbol = "H"
	_label.text = symbol


func _on_body_entered(body: Node2D) -> void:
	if !is_instance_of(body, Pchar):
		return
	(body as Pchar).get_root().collect_gate(_value)
	queue_free()
