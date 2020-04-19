extends Node2D

var velocity:Vector2 = Vector2()

export var walk_speed:int = 100
export var idle_speed:int = 15
export var time_to_idle:float = 1
export var idle_range:float = 20
export var idle_dir_change_time = 2

signal target_pos_reached

var nav2D:Navigation2D
var resource_store
var animation_handler
var collision_shape
var minion

export var debug_energystore:int = 0

var active_animation:AnimatedSprite

var is_at_ladder = false
var ladder_top
var ladder_bottom
var current_ladder_id

var current_ladder_movement = 0

var target_pos

enum MovingState {
	AtLadder,
	OnLadder,
	OnGround	
}

enum MissionState {
	AtTarget,
	InIdleTransition,
	Idle,
	GoingToTarget
}



var current_movement_dir = 0
var current_moving_state = MovingState.OnGround
var current_mission_state = MissionState.Idle
var current_idle_dir_time = 1000

var scene_timer:SceneTreeTimer

func move_to_pos(pos):
	
	current_ladder_movement = 0
	var path = nav2D.get_simple_path(global_position, pos)
	if !path.empty():		
		target_pos = path[path.size() - 1]
		current_mission_state = MissionState.GoingToTarget


# Called when the node enters the scene tree for the first time.
func _ready():
	resource_store = get_node("../ResourceStore")
	animation_handler = get_node("../AnimationHandler")
	collision_shape = get_node("../CollisionShape2D")
	minion = get_parent()
	resource_store.energy = debug_energystore
	animation_handler.update_visualization(0, resource_store.energy)
	target_pos = _get_position()


func _process(delta):
	# Get the list of points that compose the path
	pass
	
	
func _physics_process(delta):
		
	if target_pos == null:
		return
		
	if _is_at_target() && current_mission_state == MissionState.GoingToTarget:			
		current_movement_dir = 0
		current_mission_state = MissionState.AtTarget
		emit_signal("target_pos_reached")
	
				
	if current_mission_state == MissionState.AtTarget:
		scene_timer = get_tree().create_timer(time_to_idle)
		current_mission_state = MissionState.InIdleTransition
	elif current_mission_state == MissionState.InIdleTransition:
		if scene_timer.time_left <= 0:
			current_mission_state = MissionState.Idle
	elif current_mission_state == MissionState.Idle:
		current_idle_dir_time += delta
		if current_idle_dir_time >= idle_dir_change_time:
			current_idle_dir_time = 0	
			randomize()
			current_movement_dir = randi() % 3 - 1
			if target_pos.x + idle_range <= global_position.x && current_movement_dir == 1:
				current_movement_dir = -1
			elif target_pos.x - idle_range >= global_position.x && current_movement_dir == -1:
				current_movement_dir = 1
		
		global_position += current_movement_dir * Vector2.RIGHT * idle_speed * delta
		global_position.x = clamp(global_position.x, target_pos.x - idle_range, target_pos.x + idle_range)
		
		
	else:	
		var path = nav2D.get_simple_path(position, target_pos)	
			
		if path.empty():
			return
		var vec_to_target_pos = path[1] - position		
		_handle_movement(vec_to_target_pos, delta)
		
	animation_handler.update_visualization(current_movement_dir, resource_store.energy)

func _handle_movement(direction, delta_time):
	
	
	if current_moving_state == MovingState.AtLadder:
		var ladder_usage_direction = _ladder_usage_direction(direction)		
		if ladder_usage_direction == 0:	
			_move_horizontal(direction, delta_time)	
			
		else:
			current_moving_state = MovingState.OnLadder
			current_ladder_movement = ladder_usage_direction
	
	elif current_moving_state == MovingState.OnLadder:
		#print_debug("On Ladder")
		if current_ladder_movement == 0:
			current_ladder_movement = _ladder_usage_direction(direction)
		if current_ladder_movement == 1:
			if position.is_equal_approx(ladder_bottom):
				current_moving_state = MovingState.AtLadder
			
			elif is_equal_approx(position.x, ladder_bottom.x) == false:				
				var x_pos = move_toward(position.x, ladder_bottom.x, walk_speed * delta_time)
				var next_pos = Vector2(x_pos, position.y)
				next_pos.y +=  walk_speed * delta_time
				position = next_pos	
			else:
				position = position.move_toward(ladder_bottom, walk_speed * delta_time)
			
		else:
			if position.is_equal_approx(ladder_top):
				current_moving_state = MovingState.AtLadder
				
			elif is_equal_approx(position.x, ladder_top.x) == false:				
				var x_pos = move_toward(position.x, ladder_top.x, walk_speed * delta_time)
				var next_pos = Vector2(x_pos, position.y)
				next_pos.y -=  walk_speed * delta_time
				position = next_pos	
			else:
				position = position.move_toward(ladder_top, walk_speed * delta_time)
	
	elif current_moving_state == MovingState.OnGround:
		#print_debug("On Ground")
		_move_horizontal(direction, delta_time)
			

func _get_position():
	return minion.global_position
	
func _set_position(global_pos):
	minion.global_pos

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
		direction.y = 0
		position = position.move_toward(position + direction, delta_time * walk_speed)

func _is_at_target():
	var coll_shape = collision_shape
	var extents = coll_shape.shape.extents
	var x_extent = extents.x / 2
	if current_moving_state == MovingState.OnLadder:
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
	
	
func enter_ladder(top_pos, bottom_pos, id):
	if id != current_ladder_id:
		current_ladder_id = id
		current_moving_state = MovingState.AtLadder
		print_debug("Enter ladder:", id)
		ladder_top = top_pos
		ladder_bottom = bottom_pos	
	

func exit_ladder(id):
	if id == current_ladder_id:
		current_ladder_id = ""
		current_moving_state = MovingState.OnGround
		print_debug("Leave ladder:", id)
