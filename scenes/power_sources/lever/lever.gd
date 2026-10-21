class_name Lever
extends PowerSource

@onready var _interactable: Interactable = %Interactable
@onready var _sprite: ColorRect = %LeverSprite


func _ready() -> void:
	_interactable.interacted.connect(_on_interacted)


func _on_interacted() -> void:
	toggle_power()
	# TODO: add different sprite for being toggled
	_sprite.color.r = 1.0 if powered else 0.5
	_sprite.color.g = 1.0 if powered else 0.5
