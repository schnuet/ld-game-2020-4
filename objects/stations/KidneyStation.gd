extends "res://objects/stations/Station.gd";

var Minion = preload("res://objects/Minions/Minion.tscn");

signal minion_creation_requested

export var max_creatable_minions = 1;


func perform_action():
	create_minion();
	
func update():
	.update();
	max_creatable_minions = floor(max_creatable_minions * 1.25);


func get_can_create_minion():
	return get_all_minions().size() < max_creatable_minions;

func get_all_minions():
	return get_tree().get_nodes_in_group("Minion");


func create_minion():
	if (get_all_minions().size() >= max_creatable_minions):
		return false;
	
	emit_signal("minion_creation_requested");
	print(get_all_minions().size());
