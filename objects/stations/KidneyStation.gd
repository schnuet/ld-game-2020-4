extends "res://objects/stations/Station.gd";

var Minion = preload("res://objects/Minions/Minion.tscn");

signal minion_creation_requested

export var max_creatable_minions = 1;

func can_do_action():
	if (.can_do_action()):
		return can_create_minion();
	else:
		return false;

func perform_action():
	create_minion();
	
func update():
	.update();
	max_creatable_minions += upgrade_level;



func can_create_minion():
	return get_all_minions().size() < max_creatable_minions;

func get_all_minions():
	return get_tree().get_nodes_in_group("Minion");


func create_minion():
	if (!can_create_minion()): return false;
	is_working = true;
	$RoomMachine.playing = true;


func _on_RoomMachine_animation_finished():
	$RoomMachine.stop();
	emit_signal("minion_creation_requested");
	is_working = false;
