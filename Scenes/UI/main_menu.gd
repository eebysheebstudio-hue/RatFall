extends Control
class_name MainMenu
var hillScene: PackedScene = load("res://Scenes/Hill.tscn")
var players = [false,false,false,false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_focus()
	pass # Replace with function body.

func get_focus() -> void:
	$MarginContainer/VBoxContainer/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	#don't judge me
	if event.is_action_pressed("p1_start"):
		players[0] = true
		$HBoxContainer/ColorRect.set_color(Color(0,1,0,1))
	elif event.is_action_pressed("p2_start"):
		players[1] = true
		$HBoxContainer/ColorRect2.set_color(Color(0,1,0,1))
	elif event.is_action_pressed("p3_start"):
		players[2] = true
		$HBoxContainer/ColorRect3.set_color(Color(0,1,0,1))
	elif event.is_action_pressed("p4_start"):
		players[3] = true
		$HBoxContainer/ColorRect3.set_color(Color(0,1,0,1))
		
	if event.is_action_pressed("p1_back"):
		players[0] = false
		$HBoxContainer/ColorRect.set_color(Color(1,0,0,1))
	elif event.is_action_pressed("p2_back"):
		players[1] = false
		$HBoxContainer/ColorRect2.set_color(Color(1,0,0,1))
	elif event.is_action_pressed("p3_back"):
		players[2] = false
		$HBoxContainer/ColorRect3.set_color(Color(1,0,0,1))
	elif event.is_action_pressed("p4_back"):
		players[3] = false
		$HBoxContainer/ColorRect3.set_color(Color(1,0,0,1))
		
	if (event.is_action_pressed("p1_action") 
	&& $MarginContainer/VBoxContainer/Start.has_focus()
	&& players[0] == true):
		_on_start_pressed()
	
	if (event.is_action_pressed("p1_action") 
	&& $MarginContainer/VBoxContainer/Settings.has_focus()):
		_on_settings_pressed()
	
	if (event.is_action_pressed("p1_action") 
	&& $MarginContainer/VBoxContainer/Quit.has_focus()):
		_on_quit_pressed()
		
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	UiSwitcher.show_settings()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(hillScene)
	UiSwitcher.hide_all()
	#when we have the actual game, pass the list of active players
