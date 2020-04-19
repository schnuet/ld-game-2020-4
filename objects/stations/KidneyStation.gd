extends "res://objects/stations/Station.gd"

signal minion_creation_requested

var Minion = preload("res://objects/Minions/Minion.tscn");

func perform_action():	
	emit_signal("minion_creation_requested")
