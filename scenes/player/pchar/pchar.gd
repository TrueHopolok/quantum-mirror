class_name Pchar
extends CharacterBody2D

const INPUT_JUMP: StringName = &"move_jump"
const INPUT_LEFT: StringName = &"move_left"
const INPUT_RIGHT: StringName = &"move_right"

const CC_DIRS: Array[int] = [-1, 1]

@export_group("Vertical")
## Strength of the jump or initial speed player gains on using jump action.
const JUMP_FORCE: float = 275
## How fast player character can fall.
## The jumping speed is uncapped, since it is set once, while on the ground.
const MAX_FALLING_SPEED: float = 450
## Weaker gravity for player ascent.
const UP_GRAVITY: float = 750
## Stronger gravity for player descent.
const DOWN_GRAVITY: float = 1500
## Cutoff multiplier for player releasing the jump key midair.
## Used for different jump height.
const JUMP_CUTOFF_MULTIPLIER: float = 0.25
## Time buffer after jump button was pressed during which
## player would jump automatically when touched the ground.
const JUMP_BUFFER_DURATION: float = 0.2
## Time buffer allowing jumping on air right after stepping from the floor.
const COYOTE_JUMP_WINDOW: float = 0.2
## Max distance for corner correction moving vertically
const CC_VERTICAL: int = 4

@export_group("Horizontal")
## Acceleration of player running
const RUN_ACCELERATION: float = 1500
## Max running speed character can reach
const MAX_RUNNING_SPEED: float = 100
## Decelaration that is applied when player is on the ground
## and one of the following conditions are met:[br]
## - Player changed direction of movement[br]
## - Player stoped moving
const FRICTION_FORCE: float = 750
## Same as [constant FRICTION_FORCE], but is weaker and works in the air
const AIR_RESISTANCE: float = 150
## Max distance for corner correction moving horizontally
const CC_HORIZONTAL: int = 2
## Inverse movement direction duh
@export var _inverse_movement: bool = false

var _jump_buffer_remaining: float = 0  # timer variable instead of node
var _coyote_buffer_remaining: float = 0  # timer variable instead of node
var _allow_jump_cutoff: bool = false  # NOTE: assumes that going up only possible via jump

@onready var collider: CollisionShape2D = %CollisionShape2D


## Handles only players jump, since moving horizontally
## can be handled inside [method self._physics_process].
func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event.is_action_pressed(INPUT_JUMP):
		_jump_buffer_remaining = JUMP_BUFFER_DURATION


func _physics_process(delta: float) -> void:
	_handle_horizontal(delta)
	_handle_vertical(delta)
	_corner_correction(delta)
	move_and_slide()


func _handle_horizontal(delta: float) -> void:
	var input_dir: float = signf(Input.get_axis(INPUT_LEFT, INPUT_RIGHT))
	if _inverse_movement:
		input_dir = -input_dir
	var movement_dir: float = signf(velocity.x)

	# Player is moving, but tries to change dir
	# By stopping or by moving backwards
	if movement_dir != 0 && movement_dir != input_dir:
		var slowdown_force: float = FRICTION_FORCE if is_on_floor() else AIR_RESISTANCE
		velocity.x -= movement_dir * slowdown_force * delta
		# Direction is changed, clamp friction to zero
		if movement_dir != signf(velocity.x):
			velocity.x = 0

	if input_dir != 0:
		velocity.x += input_dir * RUN_ACCELERATION * delta

	velocity.x = clampf(velocity.x, -MAX_RUNNING_SPEED, MAX_RUNNING_SPEED)


func _handle_vertical(delta: float) -> void:
	if is_on_floor():
		_coyote_buffer_remaining = COYOTE_JUMP_WINDOW
		velocity.y = 0
	else:
		# Extra gravity while falling down
		if signf(velocity.y) != up_direction.y:
			velocity.y -= up_direction.y * DOWN_GRAVITY * delta
		else:
			# If still going up, but button for jump was released, cutoff the jump
			if Input.is_action_just_released(INPUT_JUMP) && _allow_jump_cutoff:
				velocity.y *= JUMP_CUTOFF_MULTIPLIER
				_allow_jump_cutoff = false
			# Weaker gravity if still during the jump
			velocity.y -= up_direction.y * UP_GRAVITY * delta

	if _coyote_buffer_remaining > 0 && _jump_buffer_remaining > 0:
		velocity.y = up_direction.y * JUMP_FORCE
		_coyote_buffer_remaining = 0
		_jump_buffer_remaining = 0
		_allow_jump_cutoff = Input.is_action_pressed(INPUT_JUMP)
		# If already is not pressing jump button
		# Then force cutoff
		if !_allow_jump_cutoff:
			velocity.y *= JUMP_CUTOFF_MULTIPLIER

	_coyote_buffer_remaining = maxf(_coyote_buffer_remaining - delta, 0)
	_jump_buffer_remaining = maxf(_jump_buffer_remaining - delta, 0)

	if up_direction.y == -1:
		velocity.y = minf(velocity.y, MAX_FALLING_SPEED)
	else:
		velocity.y = maxf(velocity.y, -MAX_FALLING_SPEED)


func _corner_correction(delta: float) -> void:
	_cc_vertical(delta)
	_cc_horizontal(delta)


func _cc_vertical(delta: float) -> void:
	if velocity.y * up_direction.y <= 0:
		return

	var movement: Vector2 = Vector2(0, velocity.y * delta)
	if !test_move(global_transform, movement):
		return

	for pos_diff: int in range(1, CC_VERTICAL + 1, 1):
		for pos_dir: float in CC_DIRS:
			var pos_delta: Vector2 = Vector2(pos_diff * pos_dir, 0)
			if !test_move(global_transform.translated(pos_delta), movement):
				global_position += pos_delta
				return


func _cc_horizontal(delta: float) -> void:
	if is_on_floor():
		return

	var input_dir: float = signf(Input.get_axis(INPUT_LEFT, INPUT_RIGHT))
	if _inverse_movement:
		input_dir = -input_dir
	if input_dir == 0 && signf(velocity.x) == 0:
		return

	var movement: Vector2 = Vector2(
		maxf(absf(velocity.x * delta), (RUN_ACCELERATION * delta) * delta), 0
	)
	if signf(velocity.x) != 0:
		movement.x *= velocity.x
	else:
		movement.x *= input_dir
	if !test_move(global_transform, movement):
		return

	for pos_diff: int in range(1, CC_HORIZONTAL + 1, 1):
		for pos_dir: float in CC_DIRS:
			var pos_delta: Vector2 = Vector2(0, pos_diff * pos_dir)
			if !test_move(global_transform.translated(pos_delta), movement):
				global_position += pos_delta
				return


## Given [Pchar], copies entire state to itself.[br]
## E.g. velocity, looking direction and etc.[br]
##
## After that enables itself to handle player's input as usual.
func enable_self(mirror: Pchar) -> void:
	velocity = Vector2(mirror.velocity.x, -mirror.velocity.y)  # -y, since up dir -1
	_jump_buffer_remaining = mirror._jump_buffer_remaining
	_coyote_buffer_remaining = mirror._coyote_buffer_remaining
	_allow_jump_cutoff = mirror._allow_jump_cutoff

	force_update_transform()
	collider.set_deferred(&"disabled", false)
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true


## Disables everything and making it invisible
func disable_self() -> void:
	collider.set_deferred(&"disabled", true)
	process_mode = Node.PROCESS_MODE_DISABLED  # handles physics as well
	visible = false


## Returns Player
func get_root() -> Player:
	## Sorry father, fo I have sinned
	## This code has no redemtion
	## But its the only thing keeping this world
	## From falling down into a pitfall
	return get_parent().get_parent()
