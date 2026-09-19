extends Control
class_name HillProgressBar
var icon_y_offset: float = 0
var icon_x_offset: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon_y_offset = $Player1Icon.size.y /2
	icon_x_offset = $Player1Icon.size.x /2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(n_player: int):
	if n_player < 1:
		$Player2Icon.show()
	if n_player < 2:
		$Player3Icon.show()
	if n_player < 3:
		$Player4Icon.show()

func on_player_death(player_index: int):
	pass

func update_progress(value: float):
	$ProgressBar.value = value
	$Player1Icon.position = Vector2(0, size.y - icon_y_offset - size.y * value / 100)
	$Player2Icon.position = Vector2(icon_x_offset, size.y - icon_y_offset - size.y * value / 100)
	$Player3Icon.position = Vector2(2 * icon_x_offset, size.y - icon_y_offset - size.y * value / 100)
	$Player4Icon.position = Vector2(3 * icon_x_offset, size.y - icon_y_offset - size.y * value / 100)
