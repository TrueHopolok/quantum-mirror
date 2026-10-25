extends CanvasLayer

@onready var _upper_viewport: SubViewport = %UpperSubViewport
@onready var _lower_viewport: SubViewport = %LowerSubViewport


func _ready() -> void:
	var shared_world: World2D = get_viewport().world_2d

	_upper_viewport.world_2d = shared_world
	_lower_viewport.world_2d = shared_world
