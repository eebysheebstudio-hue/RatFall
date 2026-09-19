extends Control
class_name MainMenu
var hillScene: PackedScene = load("res://Scenes/Hill.tscn")
var players = [false,false,false,false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p1_action"):
		players[0] = true
		$HBoxContainer/ColorRect.set_color(Color(0,1,0,1))
	elif event.is_action_pressed("p2_action"):
		players[1] = true
		$HBoxContainer/ColorRect2.set_color(Color(0,1,0,1))
	elif event.is_action_pressed("p3_action"):
		players[2] = true
		$HBoxContainer/ColorRect3.set_color(Color(0,1,0,1))
	elif event.is_action_pressed("p4_action"):
		players[3] = true
		$HBoxContainer/ColorRect3.set_color(Color(0,1,0,1))
		
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	UiSwitcher.show_settings()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(hillScene)
	UiSwitcher.hide_all()
