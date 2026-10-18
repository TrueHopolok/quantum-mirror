class_name Lever
extends PowerSource

@onready var _interactable: Interactable = %Interactable


func _ready() -> void:
	_interactable.interacted.connect(toggle_power)
