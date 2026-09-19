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
var bounds: Vector2
var n_obstacles = 20
var obstacle_scenes: Array[PackedScene] = [
	load("res://Scenes/Obstacles/Tree1.tscn"),
	load("res://Scenes/Obstacles/Tree2.tscn"),
	load("res://Scenes/Obstacles/Tree3.tscn"),
	load("res://Scenes/Obstacles/Tree4.tscn"),
	load("res://Scenes/Obstacles/Tree5.tscn"),
]

var pup_scene: PackedScene = load("res://Scenes/PowerUps/TemplatePowerUp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounds = Vector2($MovementNode/StaticBody2D/LeftBorder.position.x - 200, $MovementNode/StaticBody2D/RightBorder.position.x + 200)
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
	scatter_obstacles()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (percent_progress < 100):
		percent_progress = percent_progress + (percent_progress_speed * delta)
		$MovementNode.position = Vector2(0, -hill_height * (percent_progress / 100))
		#print(percent_progress)
		$CanvasLayer/BoxContainer/MarginContainer/HillProgressBar.update_progress(percent_progress)

func scatter_obstacles():
	var obstacles: Array[ObstacleInterface] = []
	for i in range(n_obstacles):
		var obstacle: Node2D = obstacle_scenes.pick_random().instantiate()
		var y = randf_range(0, hill_top)
		var x = randf_range(bounds.x, bounds.y)
		obstacle.position = Vector2(x, randf_range(0, -y))
		obstacles.append(obstacle)
	obstacles.sort_custom(func (a, b): return a.position.y < b.position.y)
	for obstacle in obstacles:
		$Obstacles.add_child(obstacle)

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		print("YOU DIED")


func _on_powerup_spawner_timeout() -> void:
	var pup = pup_scene.instantiate()
	var camera_pos = $MovementNode/Camera.get_screen_center_position()
	var spawn_pos = camera_pos + Vector2(randf_range(-576,576), (randf_range(-324,324)))
	pup.set_position(spawn_pos)
	$Powerups.add_child(pup)
	pass # Replace with function body.
