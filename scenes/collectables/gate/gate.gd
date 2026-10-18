class_name CollectableGate
extends Collectable

@export var _value: QuantumState.Gate

@onready var _label: Label = %ValueLabel


func _ready() -> void:
	super()
	collected.connect(_on_collected)
	var symbol: String = "?"
	match _value:
		QuantumState.Gate.X:
			symbol = "X"
		QuantumState.Gate.Z:
			symbol = "Z"
		QuantumState.Gate.H:
			symbol = "H"
	_label.text = symbol


func _on_collected(player: Player) -> void:
	player.collect_gate(_value)
	queue_free()
