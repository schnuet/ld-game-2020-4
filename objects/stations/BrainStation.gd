extends "res://objects/stations/Station.gd";

var BrainToken = preload("res://objects/token/BrainToken.tscn");

func perform_action():
	var new_token = BrainToken.instance();
	new_token.position = Vector2(100, 100);
	add_child(new_token);
