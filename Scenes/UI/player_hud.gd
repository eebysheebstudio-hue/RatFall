extends Control

var player_name: String = "" 
@export var alive_icon: Texture
@export var dead_icon: Texture
var alive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass 

func set_alive_status(alive_in: bool):
	alive = alive_in
	if alive:
		$MarginContainer/HBoxContainer/PowerUpIcon.texture = alive_icon
	else:
		$MarginContainer/HBoxContainer/PowerUpIcon.texture = dead_icon
		

		$MarginContainer/HBoxContainer/Label.text = player_name
		#TODO This comment has an unknown purpose and breaks the code names.remove_at(random_index)
		#print(names)

	
