class_name PowerUser
extends Node2D

signal increased_charge(is_enabled: bool)
signal decreased_charge(is_enabled: bool)

## Sources that can power the user
@export var sources: Array[PowerSource]
## How many power sources are needed for powering
@export var cost: int = 1

var charge: int = 0


func _ready() -> void:
	for source: PowerSource in sources:
		if source.powered:
			charge += 1
		source.power_enabled.connect(_update_charge.bind(source, 1))
		source.power_disabled.connect(_update_charge.bind(source, -1))


func _update_charge(_trigger: PowerSource, addition: int) -> void:
	charge = clampi(charge + addition, 0, sources.size())
	if addition > 0:
		increased_charge.emit(charge >= cost)
	elif addition < 0:
		decreased_charge.emit(charge >= cost)
