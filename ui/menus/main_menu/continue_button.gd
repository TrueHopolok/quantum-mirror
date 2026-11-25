extends BetterButton

var _pressed: bool = false
var _level_num: int

@onready var _continue_label: Label = $ContinueLabel


func _ready() -> void:
	super()
	_level_num = Persistence.data[Persistence.ROW_REACHED]
	if _level_num < 1:
		disabled = true
		focus_mode = Control.FOCUS_NONE
	else:
		_continue_label.text = "level %d" % _level_num


func _on_press() -> void:
	if _pressed:
		return
	_pressed = true
	Transition.change_scene_path(
		"%s/%s%d.tscn" % [Transition.LEVEL_DIR, Transition.LEVEL_PREFIX, _level_num]
	)
