extends Control

var bootScene: PackedScene = load("res://Scenes/BootLevel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func finish_game(victory: bool, winner: Player):
	$VBoxContainer/LoserInfo.hide()
	$VBoxContainer/WinnerInfo.hide()
	$VBoxContainer/MainMenuButton.grab_focus()
	if victory:
		$VBoxContainer/WinnerInfo/WinnerName.text = winner.player_name
		match winner.player_index:
			0: $VBoxContainer/WinnerInfo/WinnerIcon.texture = load("res://Assets/Visual/GameHud/Grey_Rat_Icon.png")
			1: $VBoxContainer/WinnerInfo/WinnerIcon.texture = load("res://Assets/Visual/GameHud/Black_Rat_Icon.png")
			2: $VBoxContainer/WinnerInfo/WinnerIcon.texture = load("res://Assets/Visual/GameHud/White_Rat_Icon.png")
			3: $VBoxContainer/WinnerInfo/WinnerIcon.texture = load("res://Assets/Visual/GameHud/Spotted_Rat_Icon.png")
		$VBoxContainer/WinnerInfo.show()
	else:
		$VBoxContainer/LoserInfo.show()

func _on_main_menu_button_pressed() -> void:
	print("Pressed")
	get_tree().change_scene_to_packed(bootScene)
