extends AnimatedSprite2D

var _player: Player


func _ready() -> void:
	# Acts as a LateReady
	owner.ready.connect(
		func() -> void:
			_player = %UI.get_parent() as Player
			_player.collected_gate.connect(_on_gate_applied)
			_player.state.gate_applied.connect(_on_gate_applied)
			_player.state.observed.connect(_update)
			_update()
	)


func _on_gate_applied(_op: QuantumState.Gate) -> void:
	_update()


func _update() -> void:
	frame = 2 if _player.state.split else 0
	frame += 1 if _player.state.inverse else 0
