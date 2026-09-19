extends Node2D
class_name PowerUpInterface

@export var area: Area2D = null 

var types = ["speed", "cannon", "hook"]
var pup_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_area_2d_body_entered)
	self.pup_type = types[randi_range(0,2)] #WHY IS THIS INCLUSIVE???
	#TODO: change to sprite when art assets availible
	if pup_type == "speed":
		$ColorRect.set_color(Color(1,0,0,1))
	elif pup_type == "cannon":
		$ColorRect.set_color(Color(0,1,0,1))
	elif pup_type == "hook":
		$ColorRect.set_color(Color(0,0,1,1))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		obstacle_effect(body)
		
		
func obstacle_effect(player: Player):
	print("YOU TRIGGERED THE POWER UP INTERFACE EFFECT")
	player.get_powerup(pup_type)
	self.queue_free()
	
