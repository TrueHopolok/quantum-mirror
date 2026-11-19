extends RichTextLabel

const DELAY_SHOW_DURATION: float = 0.25
const SHOW_DURATION: float = 0.5
const DELAY_HIDE_DURATION: float = 1.0
const HIDE_DURATION: float = 5.0


func _ready() -> void:
	visible_ratio = 0
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(DELAY_SHOW_DURATION)
	tween.chain().tween_property(self, "visible_ratio", 1.0, SHOW_DURATION)
	tween.chain().tween_interval(DELAY_HIDE_DURATION)
	tween.chain().tween_property(self, "modulate", Color(0, 0, 0, 0), HIDE_DURATION)
