extends BetterButton

@export_dir var _level_dir: String
@export var _level_prefix: String = "campaign_"
@export var _level_num: int = 1


func _ready() -> void:
	super()
	disabled = _level_num > 1 && _level_num > Persistence.data[Persistence.ROW_REACHED]


func _on_press() -> void:
	Transition.change_scene_path("%s/%s%d.tscn" % [_level_dir, _level_prefix, _level_num])
