extends RichTextLabel


func _ready() -> void:
	text = "[b]v[/b] %s" % ProjectSettings.get_setting("application/config/version")
