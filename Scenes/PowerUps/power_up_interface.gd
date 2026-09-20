extends Node2D
class_name PowerUpInterface

@export var area: Area2D = null
@export var pick_up_type: String = "hook"
@export var pick_up_icon: Texture2D

func _ready() -> void:
	if not area.body_entered.is_connected(_on_area_2d_body_entered):
		area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.play_particles()
		power_up_effect(body)

func power_up_effect(player: Player) -> void:
	# TODO: If adding other pickups, make an OR statement to include other pick ups so that there is a limit of one pick up at a time.
	if pick_up_type == "hook" and player.has_hook:  
		self.queue_free()
		return
	player.get_powerup(pick_up_type, pick_up_icon)
	if pick_up_type == "hook":
		player.has_hook = true
	self.queue_free()
