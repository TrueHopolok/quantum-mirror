class_name Door
extends PowerUser

@export var _single_use: bool = false

var _used: bool = false

@onready var _collider: CollisionShape2D = %StaticCollider
@onready var _sprite: ColorRect = %DoorSprite


func _ready() -> void:
	super()
	_update_state(charge >= cost, true)
	increased_charge.connect(_update_state)
	decreased_charge.connect(_update_state)


func _update_state(open: bool, skip_animation: bool = false) -> void:
	if _used && _single_use:
		return
	_used = open
	_collider.set_deferred(&"disabled", open)
	if skip_animation:
		# TODO: add different sprite for being toggled
		_sprite.color.b = 1.0 if !open else 0.5
		_sprite.color.g = 1.0 if !open else 0.5
	else:
		# TODO: add different sprite for being toggled
		_sprite.color.b = 1.0 if !open else 0.5
		_sprite.color.g = 1.0 if !open else 0.5


func reset_usage() -> void:
	_used = false
