extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_all() -> void:
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/GameOverMenu.hide()
	$CanvasLayer/SettingsMenu.hide()
	

func show_main_menu() -> void:
	$CanvasLayer/MainMenu.show()
	$CanvasLayer/GameOverMenu.hide()
	$CanvasLayer/SettingsMenu.hide()
	
func show_game_over() -> void:
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/GameOverMenu.show()
	$CanvasLayer/SettingsMenu.hide()
	
func show_settings() -> void:
	$CanvasLayer/MainMenu.hide()
	$CanvasLayer/GameOverMenu.hide()
	$CanvasLayer/SettingsMenu.show()
	
func get_main_menu() -> MainMenu:
	return $CanvasLayer/MainMenu

func _on_settings_menu_volume_changed() -> void:
	$Music.set_volume_linear((GlobalSettings.music_vol*GlobalSettings.master_vol))
	$Sfx.set_volume_linear((GlobalSettings.sfx_vol*GlobalSettings.master_vol))


func _on_main_menu_player_enter() -> void:
	$Sfx.stream = load("res://Assets/Audio/player_enter.wav")
	$Sfx.play()

func _on_main_menu_player_exit() -> void:
	$Sfx.stream = load("res://Assets/Audio/player_exit.wav")
	$Sfx.play()


func _on_button_hover() -> void:
	$Sfx.stream = load("res://Assets/Audio/menu_tick.wav")
	$Sfx.play()
