extends BetterButton

var _pressed: bool = false


func _ready() -> void:
	super()
	if !disabled:
		grab_focus()


func _on_press() -> void:
	if _pressed:
		return
	_pressed = true
	Transition.change_scene_path(
		"%s/%s%d.tscn" % [Transition.LEVEL_DIR, Transition.LEVEL_PREFIX, 1]
	)
