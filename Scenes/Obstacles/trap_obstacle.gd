extends ObstacleInterface

var stopped_duration: float = 2.0
@export var trap_sfx: AudioStreamPlayer
@export var trap_closed_particles: GPUParticles2D
@export var mouse_trap: Sprite2D
@export var open_mouse_trap1: Texture2D
@export var closed_mouse_trap1: Texture2D

func _ready() -> void:
	mouse_trap.texture = open_mouse_trap1

func obstacle_effect(player: Player) -> void:
	player.apply_stopped_state(stopped_duration)
	trap_sfx.play()
	trap_closed_particles.emitting = true
	mouse_trap.texture = closed_mouse_trap1
	await get_tree().create_timer(stopped_duration).timeout
	queue_free()
