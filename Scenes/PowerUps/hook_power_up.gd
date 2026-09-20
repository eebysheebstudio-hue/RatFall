extends PowerUpInterface

@export var hook_pick_up_sfx: AudioStreamPlayer

func power_up_effect(player: Player) -> void:
	if player.has_hook:
		return

	player.has_hook = true
	player.get_powerup(pup_type)

	if hook_pick_up_sfx:
		hook_pick_up_sfx.play()
		await hook_pick_up_sfx.finished

	queue_free()
