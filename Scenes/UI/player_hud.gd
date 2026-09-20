extends Control

var player_name: String = "" 
@export var alive_icon: Texture
@export var dead_icon: Texture
var alive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass 
	# Replace with function body.

func set_alive_status(alive_in: bool):
	alive = alive_in
	if alive:
		$MarginContainer/HBoxContainer/PowerUpIcon.texture = alive_icon
	else:
		$MarginContainer/HBoxContainer/PowerUpIcon.texture = dead_icon
		

func set_player_name(names: Array[String]):
	if player_name.is_empty():
		var random_index = randi() % names.size()
		player_name = names[random_index]
		$MarginContainer/HBoxContainer/Label.text = player_name
		names.remove_at(random_index)
		print(names)


##TODO
# Set up up to 4 players to join game (4 icons on bottom of screen)
# In order, pressing start on new controllers will allow players to join
# Spawn in a player for each player joined
# 
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
