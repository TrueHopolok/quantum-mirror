class_name CollectableGate
extends Area2D

@export var _value: QuantumState.Gate

var _glow_length: float = 5.0
var _color: Color
var _tween: Tween

@onready var _sprite: AnimatedSprite2D = %GateSprite


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	match _value:
		QuantumState.Gate.X:
			_color = Color.RED
			_glow_length = 3.0
		QuantumState.Gate.Z:
			_color = Color.BLUE
			_glow_length = 5.0
		QuantumState.Gate.H:
			_sprite.frame = 2
			_color = Color.GREEN
			_glow_length = 4.0
	_glow()


func _glow() -> void:
	if _tween:
		_tween.finished.disconnect(_glow)
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.set_trans(Tween.TRANS_EXPO)
	_tween.set_ease(Tween.EASE_IN)
	_tween.tween_property(_sprite, "modulate", _color, _glow_length / 2)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.chain().tween_property(_sprite, "modulate", Color.WHITE, _glow_length / 2)
	_tween.finished.connect(_glow)
	_tween.play()


func _on_body_entered(body: Node2D) -> void:
	if !is_instance_of(body, Pchar):
		return
	if _tween:
		_tween.finished.disconnect(_glow)
		_tween.kill()
	(body as Pchar).get_root().collect_gate(_value)
	queue_free()
