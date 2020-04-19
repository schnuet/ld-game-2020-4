extends KinematicBody2D

var velocity:Vector2 = Vector2()

export var walk_speed:int = 100
var nav2D:Navigation2D

onready var empty_walk_animation = $EmptyWalkAnimation
onready var energy_walk_animation = $EnergyWalkAnimation
onready var resource_store = $ResourceStore

export var debug_energystore:int = 0

var active_animation:AnimatedSprite

var is_at_ladder = false
var ladder_top
var ladder_bottom
var current_ladder_id

var current_ladder_movement = 0

var target_pos

enum State {
	AtLadder,
	OnLadder,
	OnGround
}

var current_movement_dir = 0


var current_state = State.OnGround

func move_to_pos(pos):
	
	current_ladder_movement = 0
	var path = nav2D.get_simple_path(global_position, pos)
	target_pos = path[path.size() - 1]


# Called when the node enters the scene tree for the first time.
func _ready():
	resource_store.energy = debug_energystore
	_activate_needed_animation()
	pass


func _process(delta):
	# Get the list of points that compose the path
	pass
	
	
func _physics_process(delta):
		
	if target_pos == null:
		return
		
	if _is_at_target():
		print("At target")
		target_pos = null
		current_movement_dir = 0
	else:	
		var path = nav2D.get_simple_path(position, target_pos)	
		
		if path.empty():
			return
			
		var vec_to_target_pos = path[1] - position
		
		_handle_movement(vec_to_target_pos, delta)
		
	_handle_visualization()

func _handle_movement(direction, delta_time):
	
	
	if current_state == State.AtLadder:
		var ladder_usage_direction = _ladder_usage_direction(direction)		
		if ladder_usage_direction == 0:	
			_move_horizontal(direction, delta_time)	
			
		else:
			current_state = State.OnLadder
			current_ladder_movement = ladder_usage_direction
	
	elif current_state == State.OnLadder:
		#print_debug("On Ladder")
		if current_ladder_movement == 0:
			current_ladder_movement = _ladder_usage_direction(direction)
		if current_ladder_movement == 1:
			if position.is_equal_approx(ladder_bottom):
				current_state = State.AtLadder
			
			elif is_equal_approx(position.x, ladder_bottom.x) == false:				
				var x_pos = move_toward(position.x, ladder_bottom.x, walk_speed * delta_time)
				var next_pos = Vector2(x_pos, position.y)
				next_pos.y +=  walk_speed * delta_time
				position = next_pos	
			else:
				position = position.move_toward(ladder_bottom, walk_speed * delta_time)
			
		else:
			if position.is_equal_approx(ladder_top):
				current_state = State.AtLadder
				
			elif is_equal_approx(position.x, ladder_top.x) == false:				
				var x_pos = move_toward(position.x, ladder_top.x, walk_speed * delta_time)
				var next_pos = Vector2(x_pos, position.y)
				next_pos.y -=  walk_speed * delta_time
				position = next_pos	
			else:
				position = position.move_toward(ladder_top, walk_speed * delta_time)
	
	elif current_state == State.OnGround:
		#print_debug("On Ground")
		_move_horizontal(direction, delta_time)
			

func _move_horizontal(direction, delta_time):
	current_movement_dir = 0
		
	if direction.x > 0:
		current_movement_dir = 1
	elif direction.x < 0:
		current_movement_dir = -1

	velocity.x = current_movement_dir * walk_speed
	if abs(velocity.x * delta_time) > abs(direction.x):
		position.x += direction.x
	else:
		velocity = move_and_slide(velocity)

func _is_at_target():
	var coll_shape = $CollisionShape2D
	var extents = coll_shape.shape.extents
	var x_extent = extents.x / 2
	if current_state == State.OnLadder:
		x_extent = extents.x * 2
	
	if abs(coll_shape.global_position.x - target_pos.x) < (x_extent):
		if abs(coll_shape.global_position.y - target_pos.y) <= (extents.y * 1.1):
			return true
	return false

# returns 0 for "should not use", 1 for "should go down", -1 for "should go up"
func _ladder_usage_direction(to_target):
	var dir = to_target.normalized().dot(Vector2.UP)
	if abs(dir) > 0.8:
		if to_target.y > 0:			
			return 1
		else:
			if (global_position + to_target).y < ladder_top.y:
				return 0
			return -1
	return 0
	

func _handle_visualization():	
	_activate_needed_animation()
		
	if current_movement_dir == 0:
		active_animation.stop()
		active_animation.frame = 0
	else:
		if current_movement_dir == -1:
			active_animation.flip_h = true
		else:
			active_animation.flip_h = false
		active_animation.play()

func _activate_needed_animation():
	if resource_store.energy > 0:
		active_animation = energy_walk_animation
		empty_walk_animation.visible = false
		energy_walk_animation.visible = true
	else:
		active_animation = empty_walk_animation
		empty_walk_animation.visible = true
		energy_walk_animation.visible = false

	
func enter_ladder(top_pos, bottom_pos, id):
	if id != current_ladder_id:
		current_ladder_id = id
		current_state = State.AtLadder
		print_debug("Enter ladder:", id)
		ladder_top = top_pos
		ladder_bottom = bottom_pos
	
	
	

func exit_ladder(id):
	if id == current_ladder_id:
		current_ladder_id = ""
		current_state = State.OnGround
		print_debug("Leave ladder:", id)
