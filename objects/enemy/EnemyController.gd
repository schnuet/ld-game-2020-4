extends Node2D

class_name Enemy

var damage:int


onready var movement_controller = $EnemyMovementController

var heart_station

var current_path:Array

func init(heart:Station, nav:Navigation2D, walk_speed:int=50, damage:int=3):
	$EnemyMovementController.nav2D = nav
	heart_station = heart
	$EnemyMovementController.walk_speed = walk_speed
	self.damage = damage
	
func enter_ladder(top_pos, bottom_pos, id):
	movement_controller.enter_ladder(top_pos, bottom_pos, id)

func exit_ladder(id):
	movement_controller.exit_ladder(id)

func go_to_position(position:Vector2):
	movement_controller.move_to_pos(position)
	
func walk_path_and_then_to_heart(path:Array):
	current_path = path
	current_path.push_back(heart_station.get_position_for_minions())
	var first_pos = current_path.pop_front()
	go_to_position(first_pos)

func _physics_process(delta):
	pass


func _on_target_pos_reached():
	if current_path.empty():
		heart_station.remove_energy(damage)
		queue_free()
	else:
		var next_pos = current_path.pop_front()
		go_to_position(next_pos)
