extends KinematicBody2D

const GRAVITY = 200.0

var velocity = Vector2()

export(int) var walk_speed = 100
export(float) var min_y_distance = 1
export(float) var min_x_distance = 0.5
var nav2D : Navigation2D

var is_at_ladder = false

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
	
	var should_use_ladder = _should_use_lader(vec_to_target_pos)
	
	if should_use_ladder == 0:
	
		var x_dir = 0
		
		if vec_to_target_pos.x > 0:
			x_dir = 1
		elif vec_to_target_pos.x < 0:
			x_dir = -1
	
		velocity.x = x_dir * walk_speed
		velocity.y += GRAVITY * delta	
	
		velocity = move_and_slide(velocity)
	
	#elif should_use_ladder == 1:
		

func is_at_target():
	var extents = $CollisionShape2D.shape.extents
	
	if abs(position.x - target_pos.x) < (extents.x / 2):
		if abs(position.y - target_pos.y) <= (extents.y * 2):
			return true
	return false

# returns 0 for "should not use", 1 for "should go down", -1 for "should go up"
func _should_use_lader(to_target):
	if abs(to_target.y) > abs(to_target.x):
		if to_target.y > 0:
			return 1
		else:
			return -1
	return 0
	

func _on_Area2D_body_entered(body):
	if target_pos == null:
		return
	var path = nav2D.get_simple_path(position, target_pos)
	if path.empty():
		return
		
	var vec_to_target_pos = path[1] - position
	if abs(vec_to_target_pos.y) > abs(vec_to_target_pos.x):
		print("Use Ladder")
	
	is_at_ladder = true
	print("At Ladder")


func _on_Area2D_body_exited(body):
	print("Exit Ladder")
