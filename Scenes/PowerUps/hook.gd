extends Node2D
class_name Hook

@export var hook_launch_sfx: AudioStreamPlayer
@export var hook_grab_sfx: AudioStreamPlayer
@export var hooked_particles: GPUParticles2D
@export var rope_scene: PackedScene
@export var hooked_duration: float = 1

var trigger_player: Player = null
var rope: HookRope = null

func activate_hook(player: Player) -> void:
	if hook_launch_sfx:
		hook_launch_sfx.play()

	trigger_player = player
	global_position = player.global_position

	# Find nearest other player. Exclude player that instantiated hook.
	var target: Player = null
	var target_distance: float = INF
	for p in get_tree().get_nodes_in_group("players"):
		if p == player:
			continue
		var d: float = p.global_position.distance_to(player.global_position)
		if d < target_distance:
			target_distance = d
			target = p

	if target == null:
		queue_free()
		return

	# Instantiate rope between player and this hook.
	if rope_scene:
		rope = rope_scene.instantiate()
		get_tree().current_scene.add_child(rope)
		rope.setup(player, self)

	# Move hook head to target player.
	var out_duration := hooked_duration
	var start_pos := global_position
	var tween_out := create_tween()
	tween_out.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween_out.tween_method(
		func(t: float):
			global_position = start_pos.lerp(target.global_position, t),
		0.0, 1.0, out_duration
	)
	await tween_out.finished

	# Grab the target.
	if hook_grab_sfx:
		hook_grab_sfx.play()
	target.apply_hook_state()
	target.reparent(self)
	target.global_position = global_position
	if hooked_particles:
		hooked_particles.emitting = true

	# Return to the trigger player with the target in tow.
	var back_duration := hooked_duration
	var return_start := global_position
	var tween_back := create_tween()
	tween_back.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_back.tween_method(
		func(t: float):
			global_position = return_start.lerp(trigger_player.global_position, t),
		0.0, 1.0, back_duration
	)
	await tween_back.finished

	# Release target.
	if is_instance_valid(target):
		target.reparent(get_tree().current_scene)
		target.current_state = Player.ClimbingState.CLIMBING

	# Clean up rope then self.
	if is_instance_valid(rope):
		rope.queue_free()
	queue_free()
