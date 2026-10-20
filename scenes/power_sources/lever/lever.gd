class_name Lever
extends PowerSource

@onready var _interactable: Interactable = %Interactable


func _ready() -> void:
	_interactable.interacted.connect(_on_interacted)


func _on_interacted() -> void:
	toggle_power()
	# TODO: add different sprite for being toggled
