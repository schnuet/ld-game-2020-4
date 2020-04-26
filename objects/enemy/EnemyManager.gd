extends Node2D

class_name EnemyManager

signal enemy_spawned

var heart_station:Station
var stomach_station:Station
var nav2D:Navigation2D

export var snail_speed:int = 50
export var snail_damage:int = 3
export var snail_health:int = 4

export var bakterie_speed:int = 80
export var bakterie_damage:int = 1
export var bakterie_health:int = 1

export var spawn_time_range:Vector2 = Vector2(20,30)
export var spawn_time_reduction:float = 1
export var upgrades_needed_for_bigger_enemy = 10

var enemy_path

var snail_enemy = preload("res://objects/enemy/Snail/Snail.tscn")
var bakterie_enemy = preload("res://objects/enemy/Bakteriophage/Bakteriophage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_path = []
	for child in $EnemyPath.get_children():
		enemy_path.push_back(child.global_position)

func init(heart_station:Station, stomach_station:Station, navigation:Navigation2D):
	self.heart_station = heart_station
	self.stomach_station = stomach_station
	self.nav2D = navigation
	$StartCooldownTimer.start();

func spawn_snail():
	var snail = snail_enemy.instance()
	_add_enemy_to_scene(snail, snail_speed, snail_damage, snail_health)	

func spawn_bakterie():
	var bakterie = bakterie_enemy.instance()
	_add_enemy_to_scene(bakterie, bakterie_speed, bakterie_damage, bakterie_health)
	
func _add_enemy_to_scene(enemy, speed, damage, health):
	enemy.init(heart_station, nav2D, speed, damage, health)
	enemy.global_position = stomach_station.get_position_for_minions()
	print(stomach_station.global_position)
	add_child(enemy)
	enemy.walk_path_and_then_to_heart(enemy_path.duplicate())


func _on_SpawnTimer_timeout():
	_spawn_enemy()
	_start_timer()

func _spawn_enemy():
	var upgrades = _total_upgrades_in_scene()
	#spawn_time_range = spawn_time_range / (float(max(upgrades,1.0)) * spawn_time_reduction)
	if upgrades >= upgrades_needed_for_bigger_enemy:
		var enemy_to_spawn = randi() % 2
		if enemy_to_spawn == 0:
			spawn_bakterie()
		else:
			spawn_snail()
	else:
		spawn_bakterie()
	emit_signal("enemy_spawned")

func _start_timer():
	randomize()
	var next_spawn_in_secs = rand_range(spawn_time_range.x, spawn_time_range.y)	
	$SpawnTimer.start(next_spawn_in_secs)

func _total_upgrades_in_scene():
	var stations = get_tree().get_nodes_in_group("Station")
	var total_count = 0
	for station in stations:
		total_count += station.upgrade_level
	return total_count


func _on_StartCooldownTimer_timeout():
	_start_timer()
