extends BetterButton


func _on_press() -> void:
	Persistence.data[Persistence.ROW_REACHED] = 6
	Persistence.data[Persistence.ROW_COMPLETED] = 6
	Persistence._save()
	Transition.reload_scene()
