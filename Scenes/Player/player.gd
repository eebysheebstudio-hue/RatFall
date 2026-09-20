extends CharacterBody2D

class_name Player

@export var hook_scene: PackedScene


const SPEED = 300.0

var player_name: String = "Nameless"
var player_index: int = 0

var horizontal_speed_multiplier: float = 1.0
var vertical_speed_multiplier: float = 1.0

var leap_speed = 0
var leap_threshold = 1
var leap_delta = 5


var vertical_climbing_speed: float = 1.0
var horizontal_climbing_speed: float = 1.0
var vertical_speed_while_falling: float = 0.0
var horizontal_speed_while_falling: float = 0.1

var speed_boost_multiplier: float = 2.5
var falling_rotation_speed: float = 10


enum ClimbingState { CLIMBING, FALLING, STOPPED, CANNON, HOOKED }

var current_state: ClimbingState = ClimbingState.CLIMBING
var speedBoostTimer: float = 0.0 

# Power ups
var power_up = ""
var has_hook: bool = false
var current_power_up_icon: Texture2D = null # send the power up's texture to display in PlayerHUD.
signal power_up_icon_changed(icon: Texture2D)

func _ready() -> void:
	$Sound.set_volume_linear(GlobalSettings.sfx_vol*GlobalSettings.master_vol)
	add_to_group("players")
	$Sprites/AnimatedSprite2D.play()	
	$Sound.stream = load("res://Assets/Audio/temp_squeak_sneaky.ogg")

func update_player_index(new_index: int):
	player_index = new_index
	match player_index:
		0:
			$Sprites/AnimatedSprite2D.sprite_frames = load("res://Scenes/Player/GreyRat.tres")
			$Sprites/StationarySprite.texture = load("res://Assets/Visual/Grey_Rat1.png")
		1:
			$Sprites/AnimatedSprite2D.sprite_frames = load("res://Scenes/Player/BlackRat.tres")
			$Sprites/StationarySprite.texture = load("res://Assets/Visual/Black_Rat1.png")
		2:
			$Sprites/AnimatedSprite2D.sprite_frames = load("res://Scenes/Player/WhiteRat.tres")
			$Sprites/StationarySprite.texture = load("res://Assets/Visual/White_Rat1.png")
		3:
			$Sprites/AnimatedSprite2D.sprite_frames = load("res://Scenes/Player/SpottedRat.tres")
			$Sprites/StationarySprite.texture = load("res://Assets/Visual/Spotted_Rat1.png")


func _physics_process(delta: float) -> void:
	if leap_speed > leap_threshold:
		leap_speed = 0
	else:
		leap_speed = leap_speed + leap_delta * delta
		if velocity.x != 0.0 || velocity.y != 0.0:
			pass
	
	if velocity.x == 0.0 && velocity.y == 0.0:
		$Sprites/StationarySprite.visible = true
		$Sprites/AnimatedSprite2D.visible = false
	else:
		$Sprites/AnimatedSprite2D.visible = true
		$Sprites/StationarySprite.visible = false
	# Speed boost
	if speedBoostTimer > 0.0:
		speedBoostTimer -= delta
	var climb_speed_y := vertical_climbing_speed
	var climb_speed_x := horizontal_climbing_speed
	if speedBoostTimer > 0.0:
		climb_speed_y *= speed_boost_multiplier
		climb_speed_x *= speed_boost_multiplier

	# State multipliers
	match current_state:
		ClimbingState.CLIMBING:
			vertical_speed_multiplier = climb_speed_y
			horizontal_speed_multiplier = climb_speed_x
		ClimbingState.FALLING:
			vertical_speed_multiplier = vertical_speed_while_falling
			horizontal_speed_multiplier = horizontal_speed_while_falling
			rotate(falling_rotation_speed * delta)
		ClimbingState.STOPPED:
			vertical_speed_multiplier = 0.0
			horizontal_speed_multiplier = 0.0
			velocity.x = 0.0
			velocity.y = 0.0
		ClimbingState.CANNON:
			vertical_speed_multiplier = vertical_speed_while_falling
			horizontal_speed_multiplier = horizontal_speed_while_falling
		ClimbingState.HOOKED:
			vertical_speed_multiplier = vertical_speed_while_falling
			horizontal_speed_multiplier = horizontal_speed_while_falling

	# Gravity only while falling
	if current_state == ClimbingState.FALLING:
		velocity += get_gravity() * delta
	# cannon moves player negitive gravity. The player falls upwards.
	elif current_state == ClimbingState.CANNON:
		velocity -= get_gravity() * delta


	# Player can't use controls and is a child of hook until they are pulled to the player that triggered the hook.
	if current_state == ClimbingState.HOOKED:
		velocity = Vector2.ZERO
		return

	# Horizontal movement
	# Check each player's number and assign the correct input.
	var p := player_index + 1  # 1, 2, 3, 4
	var left_action  := "p%d_left"  % p
	var right_action := "p%d_right" % p
	var up_action    := "p%d_up"    % p
	var down_action  := "p%d_down"  % p

	var direction := Input.get_axis(left_action, right_action)
	if direction:
		velocity.x = direction * SPEED * horizontal_speed_multiplier * leap_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Vertical movement only while climbing
	if current_state == ClimbingState.CLIMBING:
		var vdir := Input.get_axis(up_action, down_action)
		if vdir:
			velocity.y = vdir * SPEED * vertical_speed_multiplier * leap_speed
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			
	# Set player rotation
	if velocity.length() != 0:
		$Sprites.rotation = velocity.angle() + PI/2

	move_and_slide()

# State transitions


func _input(event: InputEvent) -> void:
	
	var p := player_index + 1  # Player numbers 1, 2, 3, 4
	if event.is_action_pressed("p1_test_stop") and not event.is_echo():
		apply_stopped_state(2.0)
	if event.is_action_pressed("p1_test_fall") and not event.is_echo():
		apply_falling_state(1.0)
	if event.is_action_pressed("p1_test_boost") and not event.is_echo():
		apply_speed_boost(3.0)
	if event.is_action_pressed("p1_test_cannon") and not event.is_echo():
		apply_cannon_state(1.5)
	if event.is_action_pressed("p1_test_hook") and not event.is_echo():
		spawn_hook()
	if event.is_action_pressed("p%d_action" % p) and not event.is_echo():
		if has_hook:
			has_hook = false
			use_hook()
		
func spawn_hook() -> void:
	var hook = hook_scene.instantiate()
	hook.global_position = global_position
	get_tree().current_scene.add_child(hook)

func use_hook() -> void:
	var hook = hook_scene.instantiate()
	hook.global_position = global_position
	get_tree().current_scene.add_child(hook)
	hook.activate_hook(self)
	current_power_up_icon = null
	power_up_icon_changed.emit(null)
	

func start_game() -> void:
	current_state = ClimbingState.STOPPED

func start_race() -> void:
	current_state = ClimbingState.CLIMBING

func end_race() -> void:
	current_state = ClimbingState.STOPPED

func slow_player (duration: float, percent_change: float) -> void:
# Save original speeds
	var original_vertical_climbing_speed: float = vertical_climbing_speed
	var original_horizontal_climbing_speed: float = horizontal_climbing_speed
# Change speeds by percent
	vertical_climbing_speed *= percent_change
	horizontal_climbing_speed *= percent_change
# Wait, then restore speeds
	await get_tree().create_timer(duration).timeout
	vertical_climbing_speed = original_vertical_climbing_speed
	horizontal_climbing_speed = original_horizontal_climbing_speed


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

# Hook moves player towards the other player that triggered the hook.
func apply_hook_state() -> void:
	current_state = ClimbingState.HOOKED
	
func get_powerup(type: String, icon: Texture2D) -> void:
	power_up = type
	current_power_up_icon = icon
	power_up_icon_changed.emit(icon)

func play_particles():
	$Sound.play()
	$CPUParticles2D.set_emitting(true)
	
