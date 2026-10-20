class_name Electricity
extends PowerUser

@onready var _area: Area2D = %DetectionArea
@onready var _collider: CollisionShape2D = %DetectionCollider
@onready var _sprite: ColorRect = %ElectricitySprite


func _ready() -> void:
	super()
	_update_state(charge >= cost)
	increased_charge.connect(_update_state)
	decreased_charge.connect(_update_state)


func _update_state(electro_current: bool) -> void:
	_collider.set_deferred(&"disabled", !electro_current)
	_sprite.visible = electro_current


func _physics_process(_delta: float) -> void:
	for body: Node2D in _area.get_overlapping_bodies():
		if body is Pchar:
			var player: Player = body.get_parent() as Player
			if player.state.split:
				player.handle_observation()
			else:
				player.handle_death()
			break
