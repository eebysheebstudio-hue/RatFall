extends CharacterBody2D

class_name Player

const SPEED = 300.0

var player_index: int = 0

var horizontalSpeedMultiplier: float = 1.0
var verticalSpeedMultiplier: float = 1.0

var leap_speed = 0
var leap_threshold = 1
var leap_delta = 5


var verticalClimbingSpeed: float = 1.0
var horizontalClimbingSpeed: float = 1.0
var verticalSpeedWhileFalling: float = 0.0
var horizontalSpeedWhileFalling: float = 0.1

var speedBoostMultiplier: float = 2.5
var hook_boost: float = 6.0
var falling_rotation_speed: float = 10


enum ClimbingState { CLIMBING, FALLING, STOPPED, CANNON, HOOKED }

var current_state: ClimbingState = ClimbingState.CLIMBING
var speedBoostTimer: float = 0.0

# Set by apply_hook_state() to tell _physics_process which way to push
var hook_direction: float = 0.0

var power_up = ""

func _ready() -> void:
	$Sound.set_volume_linear(GlobalSettings.sfx_vol*GlobalSettings.master_vol)
	$AnimatedSprite2D.play()


func _physics_process(delta: float) -> void:
	# TODO Fix animations to alternate between moving and landing rat
	#print("Frame is: ", $AnimatedSprite2D.frame)
	if leap_speed > leap_threshold:
		leap_speed = 0
		#$AnimatedSprite2D.set_frame_and_progress(1, 0)
	else:
		leap_speed = leap_speed + leap_delta * delta
		if velocity.x != 0.0 || velocity.y != 0.0:
			pass
	#print("state=", current_state, "  vel=", velocity, "  pos=", position)
	
	if velocity.x == 0.0 && velocity.y == 0.0:
		$StationarySprite.visible = true
	else:
		$StationarySprite.visible = false
	# Speed boost
	if speedBoostTimer > 0.0:
		speedBoostTimer -= delta
	var climb_speed_y := verticalClimbingSpeed
	var climb_speed_x := horizontalClimbingSpeed
	if speedBoostTimer > 0.0:
		climb_speed_y *= speedBoostMultiplier
		climb_speed_x *= speedBoostMultiplier

	# State multipliers
	match current_state:
		ClimbingState.CLIMBING:
			verticalSpeedMultiplier = climb_speed_y
			horizontalSpeedMultiplier = climb_speed_x
		ClimbingState.FALLING:
			verticalSpeedMultiplier = verticalSpeedWhileFalling
			horizontalSpeedMultiplier = horizontalSpeedWhileFalling
			rotate(falling_rotation_speed * delta)
		ClimbingState.STOPPED:
			verticalSpeedMultiplier = 0.0
			horizontalSpeedMultiplier = 0.0
			velocity.x = 0.0
			velocity.y = 0.0
		ClimbingState.CANNON:
			verticalSpeedMultiplier = verticalSpeedWhileFalling
			horizontalSpeedMultiplier = horizontalSpeedWhileFalling
		ClimbingState.HOOKED:
			verticalSpeedMultiplier = verticalSpeedWhileFalling
			horizontalSpeedMultiplier = horizontalSpeedWhileFalling

	# Gravity only while falling
	if current_state == ClimbingState.FALLING:
		velocity += get_gravity() * delta
	# cannon moves player negitive gravity. The player falls upwards.
	elif current_state == ClimbingState.CANNON:
		velocity -= get_gravity() * delta

	# Horizontal movement

	if current_state == ClimbingState.HOOKED:
		# hook moves player left or right. The player falls sideways
		velocity.x = hook_direction * SPEED * horizontalSpeedMultiplier * hook_boost
	else:
		var direction := Input.get_axis("p1_left", "p1_right")
		if direction:
			velocity.x = direction * SPEED * horizontalSpeedMultiplier * leap_speed
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Vertical movement only while climbing
	if current_state == ClimbingState.CLIMBING:
		var vdir := Input.get_axis("p1_up", "p1_down")
		if vdir:
			velocity.y = vdir * SPEED * verticalSpeedMultiplier * leap_speed
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			

	move_and_slide()

# State transitions


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_test_stop") and not event.is_echo():
		apply_stopped_state(2.0)
	if event.is_action_pressed("p1_test_fall") and not event.is_echo():
		apply_falling_state(1.0)
	if event.is_action_pressed("p1_test_boost") and not event.is_echo():
		apply_speed_boost(3.0)
	if event.is_action_pressed("p1_test_cannon") and not event.is_echo():
		apply_cannon_state(1.5)
	if event.is_action_pressed("p1_test_hook") and not event.is_echo():
		apply_hook_state(1, true)

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

func apply_falling_state(duration: float) -> void:
	current_state = ClimbingState.FALLING
	await get_tree().create_timer(duration).timeout
	if current_state == ClimbingState.FALLING:
		current_state = ClimbingState.CLIMBING # When falling timer is expired, climb.

# cannon moves player negitive gravity. The player falls upwards.
func apply_cannon_state(duration: float) -> void:
	current_state = ClimbingState.CANNON
	await get_tree().create_timer(duration).timeout
	if current_state == ClimbingState.CANNON:
		current_state = ClimbingState.CLIMBING # When cannon timer is expired, climb.

func apply_speed_boost(duration: float) -> void:
	speedBoostTimer = max(speedBoostTimer, duration)

# Hook moves player left or right. The player falls sideways.
func apply_hook_state(duration: float, isHookedLeft: bool) -> void:
	current_state = ClimbingState.HOOKED
	if isHookedLeft:
		hook_direction = -1.0
	else:
		hook_direction = 1.0
	await get_tree().create_timer(duration).timeout
	if current_state == ClimbingState.HOOKED:
		current_state = ClimbingState.CLIMBING # When hook timer is expired, climb.

func get_powerup(type: String) -> void:
	self.power_up = type
	$Sound.stream = load("res://Assets/Audio/temp_squeak_sneaky.ogg")
	$Sound.play()
	$CPUParticles2D.set_emitting(true)
