extends Control
class_name MainMenu
var hillScene: PackedScene = load("res://Scenes/Hill.tscn")
var players = [false,false,false,false]
signal player_enter()
signal player_exit()
signal button_sound()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_focus()

func get_focus() -> void:
	$TextureRect/MarginContainer/VBoxContainer/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	#don't judge me
	#I wound never, this is beautiful
	if event.is_action_pressed("p1_start"):
		players[0] = true
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect.set_color(Color(0.219, 0.467, 0.172, 1.0))
		player_enter.emit()
	elif event.is_action_pressed("p2_start"):
		players[1] = true
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect2.set_color(Color(0.219, 0.467, 0.172, 1.0))
		player_enter.emit()
	elif event.is_action_pressed("p3_start"):
		players[2] = true
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect3.set_color(Color(0.219, 0.467, 0.172, 1.0))
		player_enter.emit()
	elif event.is_action_pressed("p4_start"):
		players[3] = true
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect4.set_color(Color(0.219, 0.467, 0.172, 1.0))
		player_enter.emit()

	if event.is_action_pressed("p1_back") && players[0]:
		players[0] = false
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect.set_color(Color(0.663, 0.008, 0.0, 1.0))
		player_exit.emit()
	elif event.is_action_pressed("p2_back") && players[1]:
		players[1] = false
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect2.set_color(Color(0.663, 0.008, 0.0, 1.0))
		player_exit.emit()
	elif event.is_action_pressed("p3_back") && players[2]:
		players[2] = false
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect3.set_color(Color(0.663, 0.008, 0.0, 1.0))
		player_exit.emit()
	elif event.is_action_pressed("p4_back") && players[3]:
		players[3] = false
		$TextureRect/MarginContainer/VBoxContainer/PlayerIndication/ColorRect4.set_color(Color("a90200ff"))
		player_exit.emit()
		
	if (event.is_action_pressed("p1_action") 
	&& $TextureRect/MarginContainer/VBoxContainer/Start.has_focus()
	&& players[0] == true):
		_on_start_pressed()
	
	if (event.is_action_pressed("p1_action") 
	&& $TextureRect/MarginContainer/VBoxContainer/Settings.has_focus()):
		_on_settings_pressed()
	
	if (event.is_action_pressed("p1_action") 
	&& $TextureRect/MarginContainer/VBoxContainer/Quit.has_focus()):
		_on_quit_pressed()
		
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	UiSwitcher.show_settings()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(hillScene)
	UiSwitcher.hide_all()	

func _button_sound_relay() -> void:
	button_sound.emit()
