extends TextureRect

@export var _sprites: SpriteFrames
@export var _animation: StringName = &"default"

var _cur: int = 0
var _timer: float = 0.0


func _ready() -> void:
	if !_sprites.has_animation(_animation):
		return
	texture = _sprites.get_frame_texture(_animation, 0)


func _process(delta: float) -> void:
	if !_sprites.has_animation(_animation) || _cur >= _sprites.get_frame_count(_animation):
		return
	_timer += delta
	var cur_frame_length: float = (
		_sprites.get_frame_duration(_animation, _cur) / _sprites.get_animation_speed(_animation)
	)
	if _timer < cur_frame_length:
		return
	_timer = 0
	_cur = (_cur + 1) % _sprites.get_frame_count(_animation)
	texture = _sprites.get_frame_texture(_animation, _cur)
