extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_value_changed(value: float) -> void:
	GlobalSettings.music_vol = (value/100)


func _on_sfx_value_changed(value: float) -> void:
	GlobalSettings.sfx_vol = (value/100)


func _on_master_value_changed(value: float) -> void:
	GlobalSettings.master_vol = (value/100)


func _on_button_button_up() -> void:
	UiSwitcher.show_main_menu()
