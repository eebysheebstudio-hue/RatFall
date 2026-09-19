extends Node2D
var screen_speed: float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MovementNode.position = $MovementNode.position + Vector2(0, -screen_speed)


func _on_kill_box_body_entered(body: Node2D) -> void:
	if body is Player:
		print("YOU DIED")
