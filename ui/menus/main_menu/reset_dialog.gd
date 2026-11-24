extends ConfirmationDialog


func _ready() -> void:
	add_theme_icon_override("close", Texture2D.new())
	confirmed.connect(
		func() -> void:
			Persistence.reset()
			Transition.reload_scene()
	)
