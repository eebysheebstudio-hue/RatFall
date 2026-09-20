extends Node2D
class_name PowerUpInterface

@export var area: Area2D = null
@export var pup_type: String = "hook"

func _ready() -> void:
	if not area.body_entered.is_connected(_on_area_2d_body_entered):
		area.body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		power_up_effect(body)

func power_up_effect(player: Player) -> void:
	if pup_type == "hook" and player.has_hook:
		return
	player.get_powerup(pup_type)
	if pup_type == "hook":
		player.has_hook = true
	self.queue_free()
