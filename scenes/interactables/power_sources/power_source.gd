class_name PowerSource
extends Node2D

signal power_toggled(enable: bool)
signal power_enabled
signal power_disabled

@export var powered: bool = false


func enable_power() -> void:
	if powered:
		return
	powered = true
	power_toggled.emit(true)
	power_enabled.emit()


func disable_power() -> void:
	if !powered:
		return
	powered = false
	power_toggled.emit(false)
	power_disabled.emit()


func toggle_power() -> void:
	powered = !powered
	power_toggled.emit(powered)
	if powered:
		power_enabled.emit()
	else:
		power_disabled.emit()
