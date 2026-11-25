extends BetterButton

@export var _parent_menu: Control
@export var _target_menu: Control
@export var _first_focus: Control


func _ready() -> void:
	super()
	if Persistence.data[Persistence.ROW_REACHED] < 1:
		disabled = true
		focus_mode = Control.FOCUS_NONE


func _on_press() -> void:
	_parent_menu.hide()
	_target_menu.show()
	_first_focus.grab_focus()
