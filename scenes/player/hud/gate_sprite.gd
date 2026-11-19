extends AnimatedSprite2D

@export var _type: QuantumState.Gate

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
	match _type:
		QuantumState.Gate.X:
			frame = (
				10 if _player.x_gate_infinite || _player.x_gate_uses > 9 else _player.x_gate_uses
			)
		QuantumState.Gate.Z:
			frame = (
				10 if _player.z_gate_infinite || _player.z_gate_uses > 9 else _player.z_gate_uses
			)
		QuantumState.Gate.H:
			frame = (
				10 if _player.h_gate_infinite || _player.h_gate_uses > 9 else _player.h_gate_uses
			)
