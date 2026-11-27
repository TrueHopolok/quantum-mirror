extends CanvasLayer

const DURATION: float = 0.5

const LEVEL_DIR: String = "res://levels/campaign"
const LEVEL_PREFIX: String = "campaign_"

var _in_transition: bool = false
var _tween: Tween


func fade_in() -> void:
	var bg: ColorRect = $ColorRect
	bg.show()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(bg, "color", Color(0, 0, 0, 1), DURATION)
	await _tween.finished


func fade_out() -> void:
	var bg: ColorRect = $ColorRect
	_tween = create_tween()
	_tween.tween_property(bg, "color", Color(0, 0, 0, 0), DURATION)
	await _tween.finished
	bg.hide()


## Changes to given packed scene.
func change_scene_packed(scene: PackedScene) -> void:
	if _in_transition:
		printerr("[Transition]: tried to change the scene mid transition")
		return

	_in_transition = true
	await fade_in()
	get_tree().change_scene_to_packed(scene)
	get_tree().paused = false
	_in_transition = false
	await fade_out()


## Changes to scene by given path.
func change_scene_path(path: String) -> void:
	if _in_transition:
		printerr("[Transition]: tried to change the scene mid transition")
		return

	_in_transition = true
	await fade_in()
	get_tree().change_scene_to_file(path)
	get_tree().paused = false
	_in_transition = false
	await fade_out()


## Changes to given scene instance.
## Useful if scene require some prior setup e.g. gameover menu having stats from gamemanager.
##
## Example:
##	func gameover() -> void:
##		var scene: Node = load('scenes/gameover/gameover.tscn').instantiate()
##		Transition.change_scene_instance(scene)
func change_scene_instance(scene: Node) -> void:
	if _in_transition:
		printerr("[Transition]: tried to change the scene mid transition")
		return

	_in_transition = true
	await fade_in()
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
	get_tree().paused = false
	_in_transition = false
	await fade_out()


## Reloads current scene.
func reload_scene() -> void:
	if _in_transition:
		printerr("[Transition]: tried to change the scene mid transition")
		return

	_in_transition = true
	await fade_in()
	get_tree().reload_current_scene()
	get_tree().paused = false
	_in_transition = false
	await fade_out()
