extends Node2D
class_name PowerUpInterface

@export var area: Area2D = null 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_area_2d_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		obstacle_effect(body)
		
func obstacle_effect(player: Player):
	print("YOU TRIGGERED THE POWER UP INTERFACE EFFECT")
