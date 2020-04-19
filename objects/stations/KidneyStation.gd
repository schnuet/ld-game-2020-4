extends "res://objects/stations/Station.gd"

var Minion = preload("res://objects/Minions/Minion.tscn");

signal create_minion;

func perform_action():
	emit_signal("create_minion", $NewMinionPosition.position);
