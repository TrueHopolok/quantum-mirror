extends ConfirmationDialog


func _ready() -> void:
	add_theme_icon_override("close", Texture2D.new())
	confirmed.connect(
		func() -> void: Transition.change_scene_path("res://ui/menus/main_menu/main_menu.tscn")
	)
