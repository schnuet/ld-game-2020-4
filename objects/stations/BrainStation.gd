extends "res://objects/stations/Station.gd";

var BrainToken = preload("res://objects/token/BrainToken.tscn");

func perform_action():
	$RoomMachine.playing = true;

func _on_RoomMachine_animation_finished():
	$RoomMachine.playing = false;
	var new_token = BrainToken.instance();
	new_token.position = Vector2(100, 100);
	add_child(new_token);
