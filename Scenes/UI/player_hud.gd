extends Control

var player_name: String = "" 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
		
	pass 


# Assign random player name when player connects
func set_player_name(names: Array[String]):
	if player_name.is_empty():
		var random_index = randi() % names.size()
		player_name = names[random_index]
		$MarginContainer/HBoxContainer/Label.text = player_name
		names.remove_at(random_index)
		#print(names)

	
