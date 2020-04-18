extends KinematicBody2D

const GRAVITY = 200.0

var velocity = Vector2()

export(int) var walk_speed = 100
export(float) var min_y_distance = 1
export(float) var min_x_distance = 0.5
var nav2D : Navigation2D

var is_at_ladder = false
var ladder_top
var ladder_bottom

var current_ladder_movement = 0

var target_pos

enum State {
	AtLadder,
	OnLadder,
	OnGround
}



var current_state = State.OnGround

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
	
	var ladder_usage_direction = _ladder_usage_direction(vec_to_target_pos)
	if current_state == State.AtLadder:
	
		if ladder_usage_direction == 0:
	
			_move_horizontal(vec_to_target_pos)	
			
		else:
			current_state = State.OnLadder
			current_ladder_movement = ladder_usage_direction
	
	elif current_state == State.OnLadder:
		if current_ladder_movement == 1:
			if position.is_equal_approx(ladder_bottom):
				current_state = State.OnGround
			
			elif is_equal_approx(position.x, ladder_bottom.x) == false:				
				var x_pos = move_toward(position.x, ladder_bottom.x, walk_speed * delta)
				var next_pos = Vector2(x_pos, position.y)
				next_pos.y +=  walk_speed * delta
				position = next_pos	
			else:
				position = position.move_toward(ladder_bottom, walk_speed * delta)
			
		else:
			if position.is_equal_approx(ladder_top):
				current_state = State.OnGround
				
			elif is_equal_approx(position.x, ladder_top.x) == false:				
				var x_pos = move_toward(position.x, ladder_top.x, walk_speed * delta)
				var next_pos = Vector2(x_pos, position.y)
				next_pos.y -=  walk_speed * delta
				position = next_pos	
			else:
				position = position.move_toward(ladder_top, walk_speed * delta)
	
	elif current_state == State.OnGround:
		
		_move_horizontal(vec_to_target_pos)
			

func _move_horizontal(delta_target):
	var x_dir = 0
		
	if delta_target.x > 0:
		x_dir = 1
	elif delta_target.x < 0:
		x_dir = -1

	velocity.x = x_dir * walk_speed
	
	velocity = move_and_slide(velocity)

func is_at_target():
	var extents = $CollisionShape2D.shape.extents
	
	if abs(position.x - target_pos.x) < (extents.x / 2):
		if abs(position.y - target_pos.y) <= (extents.y * 2):
			return true
	return false

# returns 0 for "should not use", 1 for "should go down", -1 for "should go up"
func _ladder_usage_direction(to_target):
	if abs(to_target.y) > abs(to_target.x):
		if to_target.y > 0:
			return 1
		else:
			return -1
	return 0
	
func enter_ladder(top_pos, bottom_pos):
	ladder_top = top_pos
	ladder_bottom = bottom_pos
	
	if current_state != State.OnLadder:
		current_state = State.AtLadder
	

func exit_ladder():
	current_state = State.OnGround
