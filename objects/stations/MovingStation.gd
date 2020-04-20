extends "res://objects/stations/Station.gd"

signal started_moving

func perform_action():
	$RoomMachine.playing = true;
	emit_signal("started_moving")

func _on_RoomMachine_animation_finished():
	$RoomMachine.playing = false;
