extends Control
var hillScene: PackedScene = load("res://Scenes/Hill.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	UiSwitcher.show_settings()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(hillScene)
	UiSwitcher.hide_all()
