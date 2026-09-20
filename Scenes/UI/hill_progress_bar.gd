extends Control
class_name HillProgressBar
var icon_y_offset: float = 0
var icon_x_offset: float = 0
var icon_x_start: float = 0
var progress_bar_height = 415
var is_player_alive = [false, false, false, false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#progress_bar_height = $TextureRect/MarginContainer/ProgressBar.size.y
	icon_y_offset = 15 + $Player1Icon.size.y /2
	icon_x_offset = $Player1Icon.size.x /2
	icon_x_start = 0
	$Player1Icon.position = Vector2(icon_x_start, size.y - icon_y_offset)
	$Player2Icon.position = Vector2(icon_x_start  + icon_x_offset, size.y - icon_y_offset)
	$Player3Icon.position = Vector2(icon_x_start + 2 * icon_x_offset, size.y - icon_y_offset)
	$Player4Icon.position = Vector2(icon_x_start + 3 * icon_x_offset, size.y - icon_y_offset)

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_player_alive(player_index: int, is_alive: bool):
	is_player_alive[player_index] = is_alive

func update_progress(value: float):
	$TextureRect/MarginContainer/ProgressBar.value = value
	if is_player_alive[0]: $Player1Icon.position = Vector2(icon_x_start, size.y - icon_y_offset - progress_bar_height * value / 100)
	if is_player_alive[1]: $Player2Icon.position = Vector2(icon_x_start + icon_x_offset, size.y - icon_y_offset - progress_bar_height * value / 100)
	if is_player_alive[2]: $Player3Icon.position = Vector2(icon_x_start + 2 * icon_x_offset, size.y - icon_y_offset - progress_bar_height * value / 100)
	if is_player_alive[3]: $Player4Icon.position = Vector2(icon_x_start + 3 * icon_x_offset, size.y - icon_y_offset - progress_bar_height * value / 100)
