extends BetterButton


func _ready() -> void:
	super()
	if !OS.is_debug_build():
		hide()
		disabled = true
		focus_mode = Control.FOCUS_NONE


func _on_press() -> void:
	Persistence.data[Persistence.ROW_REACHED] = 6
	Persistence.data[Persistence.ROW_COMPLETED] = 6
	Persistence._save()
	Transition.reload_scene()
