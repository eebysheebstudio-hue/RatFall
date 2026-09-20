extends Node2D
var hill_bottom: float = 0.0
var hill_top = 10000.0
var percent_progress_speed: float = 1 # Moves X% of the hill per second 
var percent_progress: float = 100
var cats_entry_percent = 100
var cats_entry_percent_speed = 5
var cats_entry_offset = 350
var intro_camera_accel: float = 0.0
var bring_in_cats = false
var text_cutscene_started = false
var started: bool = false
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
var living_player_indexes: Array[int] = []

var pup_scene: PackedScene = load("res://Scenes/PowerUps/TemplatePowerUp.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounds = Vector2($MovementNode/StaticBody2D/LeftBorder.position.x - 200, $MovementNode/StaticBody2D/RightBorder.position.x + 200)
	var players_connected = UiSwitcher.get_main_menu().players
	for player_index in range(players_connected.size()):
		if players_connected[player_index]:
			var player: Player = player_scene.instantiate()
			player.update_player_index(player_index)
			player.position.x = player_index * player_spawn_spacing
			player.position = player.position + player_spawn_offset
			#print("adding player")
			$Players.add_child(player)
			
			var random_index = randi() % names.size()
			var player_name = names[random_index]
			names.remove_at(random_index)
			player.player_name = player_name
			match player_index:
				0:  
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_player_name(player_name)
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_alive_status(true)
				1: 	
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud2.set_player_name(player_name)
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud2.set_alive_status(true)
				2: 	
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud3.set_player_name(player_name)
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud3.set_alive_status(true)
				3: 	
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud4.set_player_name(player_name)
					$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud4.set_alive_status(true)
			$CanvasLayer/BoxContainer/MarginContainer/HillProgressBar.set_player_alive(player_index, true)
			living_player_indexes.append(player_index)
	hill_height = hill_top - hill_bottom
	$MovementNode.position = Vector2(0, hill_bottom)
	scatter_obstacles()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not text_cutscene_started and percent_progress > 0:
		intro_camera_accel = intro_camera_accel + 5 * delta
		percent_progress = max(0, percent_progress - (percent_progress_speed * intro_camera_accel * delta))
		$MovementNode/Camera.position = Vector2(0, -hill_height * (percent_progress / 100))
	if not text_cutscene_started and percent_progress <= 0:
		text_cutscene_started = true
		run_text_cut_scene()
	if bring_in_cats and cats_entry_percent > 0:
		cats_entry_percent = max(0, cats_entry_percent - cats_entry_percent_speed * delta)
		$MovementNode/Cats.position.y = cats_entry_offset * cats_entry_percent / 100
	if started and percent_progress < 100:
		percent_progress = percent_progress + (percent_progress_speed * delta)
		$MovementNode.position = Vector2(0, -hill_height * (percent_progress / 100))
		$CanvasLayer/BoxContainer/MarginContainer/HillProgressBar.update_progress(percent_progress)

func run_text_cut_scene():
	$CanvasLayer/Label.text = "GET"
	await get_tree().create_timer(1.0).timeout
	$CanvasLayer/Label.text = "THAT"
	await get_tree().create_timer(1.0).timeout
	$CanvasLayer/Label.text = "CHEESE"
	await get_tree().create_timer(1.0).timeout
	$CanvasLayer/Label.text = ""
	started = true
	await get_tree().create_timer(10.0).timeout
	bring_in_cats = true
	
func scatter_obstacles():
	var obstacles: Array[ObstacleInterface] = []
	for i in range(n_obstacles):
		var obstacle: Node2D = obstacle_scenes.pick_random().instantiate()
		var y = randf_range(-hill_top, -1000)
		var x = randf_range(bounds.x, bounds.y)
		obstacle.position = Vector2(x, randf_range(0, -y))
		obstacles.append(obstacle)
	obstacles.sort_custom(func (a, b): return a.position.y < b.position.y)
	for obstacle in obstacles:
		$Obstacles.add_child(obstacle)

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		match body.player_index:
			0: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_alive_status(false)
			1: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_alive_status(false)
			2: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_alive_status(false)
			3: 	$CanvasLayer/BoxContainer/HillHud/HBoxContainer/PlayerHud.set_alive_status(false)
		$CanvasLayer/BoxContainer/MarginContainer/HillProgressBar.set_player_alive(body.player_index, false)
		living_player_indexes.erase(body.player_index)
		print(living_player_indexes.size())
		if living_player_indexes.is_empty():
			UiSwitcher.finish_game(false, body)
		#TODO: have a death sound effect, particle effect too

# Test game over screen (press LB)
func _input(event: InputEvent) -> void:
		if event.is_action_pressed("GameOver"):
			UiSwitcher.finish_game(false, null)

func _on_powerup_spawner_timeout() -> void:
	var pup = pup_scene.instantiate()
	var camera_pos = $MovementNode/Camera.get_screen_center_position()
	var spawn_pos = camera_pos + Vector2(randf_range(-576,576), (randf_range(-324,324)))
	pup.set_position(spawn_pos)
	$Powerups.add_child(pup)
	pass # Replace with function body.
