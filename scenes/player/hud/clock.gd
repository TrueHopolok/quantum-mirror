extends Sprite2D

const SHOW_CLOCK: StringName = &"show_clock"
const DURATION: float = 0.2
const DEACTIVATE_POS: Vector2 = Vector2(-5.0, 180.0)
const ACTIVE_POS: Vector2 = Vector2(40.0, 180.0)

var _tween: Tween
var _active: bool = false


func _process(_delta: float) -> void:
	if _active != Input.is_action_pressed(SHOW_CLOCK):
		_active = Input.is_action_pressed(SHOW_CLOCK)
		if _tween:
			_tween.kill()
		_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		_tween.tween_property(self, "position", ACTIVE_POS if _active else DEACTIVATE_POS, DURATION)
