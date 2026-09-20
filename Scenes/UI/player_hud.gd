extends Control

var player_name: String = "" 
@export var alive_icon: Texture
@export var dead_icon: Texture
@export var bg_texture: Texture
@export var player_image: TextureRect
var alive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$Background.texture = bg_texture
	player_image.texture = dead_icon

func set_alive_status(alive_in: bool):
	alive = alive_in
	if alive:
		player_image.texture = alive_icon
	else:
		player_image.texture = dead_icon
		

func set_player_name(name: String):
	player_name = name
	$MarginContainer/HBoxContainer/Label.text = player_name

func set_power_up_icon(icon: Texture2D) -> void:
	if icon == null: player_image.texture = alive_icon
	else: player_image.texture = icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
