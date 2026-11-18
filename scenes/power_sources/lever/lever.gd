class_name Lever
extends PowerSource

## Propogates into interactable
## so there would be no need to edit children
@export var _single_use: bool = false

@onready var _interactable: Interactable = %Interactable
@onready var _sprite: AnimatedSprite2D = %LeverSprite


func _ready() -> void:
	_interactable.single_use = _single_use
	_interactable.interacted.connect(_on_interacted)
	_sprite.frame = 1 if powered else 0


func _on_interacted() -> void:
	toggle_power()
	_sprite.frame = 1 if powered else 0
