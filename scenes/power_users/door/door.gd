class_name Door
extends PowerUser

@export var _single_use: bool = false

var _used: bool = false
var _tween: Tween

@onready var _collider: CollisionShape2D = %StaticCollider
@onready var _sprite: AnimatedSprite2D = %DoorSprite
@onready var _label: Label = %DoorLabel


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
	_label.text = str(absi(cost - charge))
	if _tween:
		_tween.kill()
	if skip_animation:
		# TODO: add different sprite for being toggled
		_sprite.visible = !open
	else:
		# TODO: add different sprite for being toggled
		_sprite.visible = !open


func reset_usage() -> void:
	_used = false
