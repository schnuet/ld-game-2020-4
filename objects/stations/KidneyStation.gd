extends "res://objects/stations/Station.gd"

signal minion_created

var Minion = preload("res://objects/Minions/Minion.tscn");
var nav2D : Navigation2D

var idle_minions = []
	

func perform_action():	
	_create_minion()
	

func _create_minion():
	var minion = Minion.instance()
	minion.nav2D = nav2D
	minion.global_position = $NewMinionPosition.global_position
	get_tree().root.add_child(minion)
	idle_minions.push_back(minion)
	emit_signal("minion_created", minion)
