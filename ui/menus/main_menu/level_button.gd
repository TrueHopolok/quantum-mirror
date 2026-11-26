extends BetterButton

@export var _level_num: int = 1

var _pressed: bool = false


func _ready() -> void:
	super()
	disabled = (
		disabled || (_level_num > 1 && _level_num > Persistence.data[Persistence.ROW_REACHED])
	)
	if disabled:
		focus_mode = Control.FOCUS_NONE
	else:
		text = "Level %d" % _level_num


func _on_press() -> void:
	if _pressed:
		return
	_pressed = true
	Transition.change_scene_path(
		"%s/%s%d.tscn" % [Transition.LEVEL_DIR, Transition.LEVEL_PREFIX, _level_num]
	)
