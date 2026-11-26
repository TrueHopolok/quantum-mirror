extends PowerUser

const RAD_PER_SEC: float = 2 * PI / 20


func _process(delta: float) -> void:
	rotate(RAD_PER_SEC * delta)
