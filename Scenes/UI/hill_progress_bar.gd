extends Control
class_name HillProgressBar

var icon_y_offset: float = 0
var icon_x_offset: float = 0
var icon_x_start: float = 0
var progress_bar_height: float = 415
var is_player_alive := [false, false, false, false]
var icons: Array[Control]

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	# Turn off images
	icons = [$Player1Icon, $Player2Icon, $Player3Icon, $Player4Icon]
	icon_y_offset = 15 + icons[0].size.y / 2
	icon_x_offset = icons[0].size.x / 2
	icon_x_start = 0

	for i in icons.size():
		icons[i].visible = false

# Check active players and activate their icons
	for p in get_tree().get_nodes_in_group("players"):
		if p is Player:
			var i: int = p.player_index
			icons[i].visible = true
			icons[i].position = Vector2(icon_x_start + i * icon_x_offset, size.y - icon_y_offset)


func set_player_alive(player_index: int, alive: bool) -> void:
	is_player_alive[player_index] = alive

func update_progress(value: float) -> void:
	$TextureRect/MarginContainer/ProgressBar.value = value
	var y := size.y - icon_y_offset - progress_bar_height * value / 100
	for i in icons.size():
		if is_player_alive[i]:
			icons[i].position = Vector2(icon_x_start + i * icon_x_offset, y)
