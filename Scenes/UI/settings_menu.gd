extends Control

signal volume_changed()
signal button_sound()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_value_changed(value: float) -> void:
	GlobalSettings.music_vol = (value/100)
	volume_changed.emit()

func _on_sfx_value_changed(value: float) -> void:
	GlobalSettings.sfx_vol = (value/100)
	volume_changed.emit()


func _on_master_value_changed(value: float) -> void:
	GlobalSettings.master_vol = (value/100)
	volume_changed.emit()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("p1_back")):
		UiSwitcher.show_main_menu()

func _on_button_button_up() -> void:
	UiSwitcher.show_main_menu()
	
func _button_sound_relay() -> void:
	button_sound.emit()
