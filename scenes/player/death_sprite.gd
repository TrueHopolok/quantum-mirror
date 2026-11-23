extends AnimatedSprite2D


func _ready() -> void:
	animation_finished.connect(func() -> void: hide())
