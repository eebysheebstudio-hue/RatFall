extends ObstacleInterface

var dir = -1
var speed = 100
var y_offset = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	y_offset = position.y
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", y_offset-50, 1)
	tween.tween_property(self, "position:y", y_offset+50, 1)
	pass # Replace with function body.

func _process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position + Vector2(200 * dir, 0))
	var result = space_state.intersect_ray(query)
	if result:
		$Sprite2D.scale.x = dir * 0.1
		dir = -dir
		print("YAY")
	position.x += dir * speed * delta
	

func obstacle_effect(player: Player) -> void:
	player.apply_falling_state(1)
