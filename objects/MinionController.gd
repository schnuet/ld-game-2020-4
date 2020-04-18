extends KinematicBody2D

const GRAVITY = 200.0

var velocity = Vector2()

export(int) var walk_speed = 100
export(float) var min_y_distance = 1
export(float) var min_x_distance = 0.5
var nav2D : Navigation2D


var target_pos

func move_to_pos(pos):
	target_pos = pos


# Called when the node enters the scene tree for the first time.
func _ready():
	#nav2D = get_tree().get_node("Navigation2D")
	pass


func _process(delta):
	# Get the list of points that compose the path
	pass
	
	
func _physics_process(delta):
		
	if target_pos == null:
		return
		
	if is_at_target():
		print("At target")
		target_pos = null
		return
	
	var path = nav2D.get_simple_path(position, target_pos)	
	
	if path.empty():
		return
	
	var vec_to_target_pos = path[1] - position
	var x_dir = 0
	
	if vec_to_target_pos.x > 0:
		x_dir = 1
	elif vec_to_target_pos.x < 0:
		x_dir = -1

	velocity.x = x_dir * walk_speed
	velocity.y += GRAVITY * delta	

	velocity = move_and_slide(velocity)

func is_at_target():
	var extents = $CollisionShape2D.shape.extents
	
	if abs(position.x - target_pos.x) < (extents.x / 2):
		if abs(position.y - target_pos.y) <= (extents.y * 2):
			return true
	return false
