extends Control

var player_name: String = "" 
@export var alive_icon: Texture
@export var dead_icon: Texture
@export var bg_texture: Texture
var alive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$Background.texture = bg_texture
	$MarginContainer/HBoxContainer/PowerUpIcon.texture = dead_icon

func set_alive_status(alive_in: bool):
	alive = alive_in
	if alive:
		$MarginContainer/HBoxContainer/PowerUpIcon.texture = alive_icon
	else:
		$MarginContainer/HBoxContainer/PowerUpIcon.texture = dead_icon
		

func set_player_name(name: String):
	player_name = name
	$MarginContainer/HBoxContainer/Label.text = player_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
