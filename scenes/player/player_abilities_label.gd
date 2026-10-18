extends Label

var _player: Player


func _ready() -> void:
	# Acts as a LateReady
	owner.ready.connect(
		func() -> void:
			_player = %UI.get_parent() as Player
			_player.collected_gate.connect(_on_gate_applied)
			_player.state.gate_applied.connect(_on_gate_applied)
			_player.state.observed.connect(_update_text)
			_update_text()
	)


func _on_gate_applied(_op: QuantumState.Gate) -> void:
	_update_text()


func _update_text() -> void:
	var x: String = "inf" if _player.x_gate_infinite else str(_player.x_gate_uses)
	var z: String = "inf" if _player.z_gate_infinite else str(_player.z_gate_uses)
	var h: String = "inf" if _player.h_gate_infinite else str(_player.h_gate_uses)
	text = (
		'''X: %s
Z: %s
H %s
S = %s'''
		% [x, z, h, _player.state]
	)
