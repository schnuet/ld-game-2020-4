extends Node2D

var heart_station:Station
var stomach_station:Station
var nav2D:Navigation2D

export var snail_speed:int = 50
export var snail_damage:int = 3

export var bakterie_speed:int = 80
export var bakterie_damage:int = 1

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

func spawn_snail():
	var snail = snail_enemy.instance()
	_add_enemy_to_scene(snail, snail_speed, snail_damage)	

func spawn_bakterie():
	var bakterie = bakterie_enemy.instance()
	_add_enemy_to_scene(bakterie, bakterie_speed, bakterie_damage)
	
func _add_enemy_to_scene(enemy, speed, damage):
	enemy.init(heart_station, nav2D, speed, damage)
	enemy.global_position = stomach_station.get_position_for_minions()
	print(stomach_station.global_position)
	add_child(enemy)
	enemy.walk_path_and_then_to_heart(enemy_path.duplicate())
