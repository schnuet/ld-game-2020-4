extends "res://objects/stations/Station.gd"

signal minion_creation_requested

var Minion = preload("res://objects/Minions/Minion.tscn");
var nav2D : Navigation2D

var idle_minions = []

func perform_action():	
	emit_signal("minion_creation_requested")
