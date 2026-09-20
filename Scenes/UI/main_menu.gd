extends Control
class_name MainMenu
var hillScene: PackedScene = load("res://Scenes/Hill.tscn")
var players = [false,false,false,false]
signal player_enter()
signal player_exit()
signal button_hover()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	#don't judge me
	if event.is_action_pressed("p1_action") && !players[0]:
		players[0] = true
		$HBoxContainer/ColorRect.set_color(Color(0,1,0,1))
		player_enter.emit()
	elif event.is_action_pressed("p2_action") && !players[1]:
		players[1] = true
		$HBoxContainer/ColorRect2.set_color(Color(0,1,0,1))
		player_enter.emit()
	elif event.is_action_pressed("p3_action") && !players[2]:
		players[2] = true
		$HBoxContainer/ColorRect3.set_color(Color(0,1,0,1))
		player_enter.emit()
	elif event.is_action_pressed("p4_action") && !players[3]:
		players[3] = true
		$HBoxContainer/ColorRect3.set_color(Color(0,1,0,1))
		player_enter.emit()
		
	if event.is_action_pressed("p1_back") && players[0]:
		players[0] = false
		$HBoxContainer/ColorRect.set_color(Color(1,0,0,1))
		player_exit.emit()
	elif event.is_action_pressed("p2_back") && players[1]:
		players[1] = false
		$HBoxContainer/ColorRect2.set_color(Color(1,0,0,1))
		player_exit.emit()
	elif event.is_action_pressed("p3_back") && players[2]:
		players[2] = false
		$HBoxContainer/ColorRect3.set_color(Color(1,0,0,1))
		player_exit.emit()
	elif event.is_action_pressed("p4_back") && players[3]:
		players[3] = false
		$HBoxContainer/ColorRect3.set_color(Color(1,0,0,1))
		player_exit.emit()
		
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	UiSwitcher.show_settings()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(hillScene)
	UiSwitcher.hide_all()
	#when we have the actual game, pass the list of active players
	
func _button_hover_relay() -> void:
	button_hover.emit()
