extends Line2D
class_name HookRope

var source_player: Node2D = null
var target_hook: Node2D = null

# Make two points. One for each end of the rope.
func setup(player_source_node: Node2D, player_target_node: Node2D) -> void:
	source_player = player_source_node
	target_hook = player_target_node
	clear_points()
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)

# Stretch the rope between the two points.
func _process(_delta: float) -> void:
	if not is_instance_valid(source_player) or not is_instance_valid(target_hook):
		queue_free()
		return
	global_position = Vector2.ZERO
	global_rotation = 0.0
	set_point_position(0, source_player.global_position)
	set_point_position(1, target_hook.global_position)
