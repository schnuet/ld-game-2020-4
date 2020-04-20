extends Node2D

var heart_station:Station
var stomach_station:Station
var nav2D:Navigation2D

var enemy_path

var snail_enemy = preload("res://objects/enemy/Snail/Snail.tscn")

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
	snail.init(heart_station, nav2D)
	snail.global_position = stomach_station.get_position_for_minions()
	print(stomach_station.global_position)
	add_child(snail)
	snail.walk_path_and_then_to_heart(enemy_path.duplicate())
