class_name Door
extends PowerUser

@onready var _collider: CollisionShape2D = %StaticCollider


func _ready() -> void:
	super()
	_update_state(charge >= cost)
	increased_charge.connect(_update_state)
	decreased_charge.connect(_update_state)


func _update_state(open: bool) -> void:
	_collider.set_deferred(&"disabled", open)
