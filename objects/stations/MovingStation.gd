extends "res://objects/stations/Station.gd"

signal started_moving

func perform_action():
	emit_signal("started_moving")
