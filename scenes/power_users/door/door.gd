class_name Door
extends PowerUser

@onready var _collider: CollisionShape2D = %StaticCollider
@onready var _sprite: ColorRect = %DoorSprite


func _ready() -> void:
	super()
	_update_state(charge >= cost, true)
	increased_charge.connect(_update_state)
	decreased_charge.connect(_update_state)


func _update_state(open: bool, skip_animation: bool = false) -> void:
	_collider.set_deferred(&"disabled", open)
	if skip_animation:
		_sprite.visible = !open
	else:
		_sprite.visible = !open  # TODO: add proper animation
