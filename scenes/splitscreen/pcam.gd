extends Camera2D

@export var _pchar: Pchar
@export var _spawn_area: SpawnArea


func _ready() -> void:
	assert(
		is_instance_valid(_pchar) && is_instance_valid(_spawn_area),
		"PCam._ready(): targets are invalid"
	)

	make_current()


func _physics_process(_delta: float) -> void:
	if _pchar.process_mode == PROCESS_MODE_DISABLED:
		global_position = _spawn_area.global_position
	else:
		global_position = _pchar.global_position
