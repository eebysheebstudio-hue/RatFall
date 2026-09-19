extends Node2D
var hill_bottom: float = 0.0
var hill_top = 1000.0
var percent_progress_speed: float = 5 # Moves X% of the hill per second 
var percent_progress: float = 0.0
var hill_height: float
var players: Array[Player]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hill_height = hill_top - hill_bottom
	$MovementNode.position = Vector2(0, hill_bottom)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (percent_progress < 100):
		percent_progress = percent_progress + (percent_progress_speed * delta)
		$MovementNode.position = $MovementNode.position + Vector2(0, -hill_height * percent_progress / 100)
		$CanvasLayer/MarginContainer/HillProgressBar.update_progress(percent_progress)

func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		print("YOU DIED")
