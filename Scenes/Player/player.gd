extends CharacterBody2D

class_name Player

const SPEED = 300.0

var horizontalSpeedMultiplier: float = 0.1
var verticalSpeedMultiplier: float = 0.1

@export var verticalClimbingSpeed: float = 0.1
@export var horizontalClimbingSpeed: float = 0.08
@export var verticalSpeedWhileFalling: float = 0.0
@export var horizontalSpeedWhileFalling: float = 0.05

@export var speedBoostMultiplier: float = 2.0

enum ClimbingState { CLIMBING, FALLING, STOPPED }

var current_state: ClimbingState = ClimbingState.CLIMBING
var speedBoostTimer: float = 0.0


func _physics_process(delta: float) -> void:
	print("state=", current_state, "  vel=", velocity, "  pos=", position)
		# Speed boost
	if speedBoostTimer > 0.0:
		speedBoostTimer -= delta
	var climb_speed := verticalClimbingSpeed
	if speedBoostTimer > 0.0:
		climb_speed *= speedBoostMultiplier

	# State multipliers
	match current_state:
		ClimbingState.CLIMBING:
			verticalSpeedMultiplier = climb_speed
			horizontalSpeedMultiplier = horizontalClimbingSpeed
		ClimbingState.FALLING:
			verticalSpeedMultiplier = verticalSpeedWhileFalling
			horizontalSpeedMultiplier = horizontalSpeedWhileFalling
		ClimbingState.STOPPED:
			verticalSpeedMultiplier = 0.0
			horizontalSpeedMultiplier = 0.0

	# Gravity only while falling
	#if current_state == ClimbingState.FALLING:
	#	velocity += get_gravity() * delta

	# Horizontal movement
	var direction := Input.get_axis("p1_left", "p1_right")
	if direction:
		velocity.x = direction * SPEED * horizontalSpeedMultiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Vertical movement only while climbing
	if current_state == ClimbingState.CLIMBING:
		var vdir := Input.get_axis("p1_up", "p1_down")
		if vdir:
			velocity.y = vdir * SPEED * verticalSpeedMultiplier
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

# State transitions

func start_game() -> void:
	current_state = ClimbingState.STOPPED

func start_race() -> void:
	current_state = ClimbingState.CLIMBING

func end_race() -> void:
	current_state = ClimbingState.STOPPED

func apply_stopped_state(duration: float) -> void:
	current_state = ClimbingState.STOPPED
	await get_tree().create_timer(duration).timeout
	if current_state == ClimbingState.STOPPED:
		current_state = ClimbingState.CLIMBING # When stopped timer is expired, climb

func apply_falling_state (duration: float) -> void:
	current_state = ClimbingState.FALLING
	await get_tree().create_timer(duration).timeout
	if current_state == ClimbingState.FALLING:
		current_state = ClimbingState.CLIMBING # When falling timer is expired, climb

func apply_speed_boost(duration: float) -> void:
	speedBoostTimer = max(speedBoostTimer, duration)
