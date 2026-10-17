class_name QuantumState
extends Resource

signal observed

enum Gate {
	X,
	H,
	Z,
}

@export var inverse: bool = false
@export var split: bool = false


func _to_string() -> String:
	var output: String = "|%s>"
	if split:
		output = output % ("-" if inverse else "+")
	else:
		output = output % ("1" if inverse else "0")
	return output


## Applies gate operation and returns
## whether or not operation it succeeded.
func apply_gate(op: Gate) -> bool:
	match op:
		Gate.X:
			if split:
				return false
			inverse = !inverse
		Gate.H:
			split = !split
		Gate.Z:
			if !split:
				return false
			inverse = !inverse
		_:
			return false
	return true


## State is being observed.
## Since in game state has only 50/50 probability
## observation can be simplified to randomly selecting inverse state.[br]
##
## Returns whether or not observation has any effect aka state is in superpos.[br]
## Additionally emits a singal [signal QuantumState.observed] on success.
func apply_observation() -> bool:
	if !split:
		return false
	split = false
	inverse = randi() % 2 == 1
	observed.emit()
	return true
