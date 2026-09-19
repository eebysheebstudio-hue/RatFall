extends Node2D
var hill_bottom: float = 0.0
var hill_top = 10000.0
var percent_progress_speed: float = 1 # Moves X% of the hill per second 
var percent_progress: float = 0.0
var hill_height: float
var players: Array[Player]
var names: Array[String] = ["Nibbler", "Sniffles", "Wormtail", "Patchy", "Swipes", "Swiftfoot", "Pipsqueak"]
var player_scene: PackedScene = load("res://Scenes/Player/Player.tscn")
var player_spawn_spacing = 100
var player_spawn_offset = Vector2(-200, 150)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players_connected = UiSwitcher.get_main_menu().players
	for player_index in range(players_connected.size()):
		if players_connected[player_index]:
			var player = player_scene.instantiate()
			player.position.x = player_index * player_spawn_spacing
			player.position = player.position + player_spawn_offset
			#print("adding player")
			$Players.add_child(player)
			match player_index:
				0: $CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_player_name(names)
				1: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud2.set_player_name(names)
				2: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud3.set_player_name(names)
				3: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud4.set_player_name(names)
	hill_height = hill_top - hill_bottom
	$MovementNode.position = Vector2(0, hill_bottom)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (percent_progress < 100):
		percent_progress = percent_progress + (percent_progress_speed * delta)
		$MovementNode.position = Vector2(0, -hill_height * (percent_progress / 100))
		print(percent_progress)
		$CanvasLayer/BoxContainer/MarginContainer/HillProgressBar.update_progress(percent_progress)

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		print("YOU DIED")
