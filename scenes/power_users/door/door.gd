class_name Door
extends PowerUser

const UPWARDS_MOVE: int = 30  # pixels
const INIT_DELTA: int = 4  # pixels
const OPEN_LENGTH: float = 0.25

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
	var new_pos: Vector2 = (
		Vector2(0, -UPWARDS_MOVE - INIT_DELTA) if open else Vector2(0, -INIT_DELTA)
	)
	if _tween:
		_tween.kill()
	if skip_animation:
		_sprite.position = new_pos
	else:
		_tween = (get_tree().create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT))
		_tween.tween_property(_sprite, "position", new_pos, OPEN_LENGTH)


func reset_usage() -> void:
	_used = false
