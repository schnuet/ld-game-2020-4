extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if get_node("KinematicBody2D/ResourceStore").energy > 0:
			get_node("KinematicBody2D/ResourceStore").take_energy(1)
		else:
			get_node("KinematicBody2D/ResourceStore").add_energy(1)

	if Input.is_action_just_pressed("ui_down"):
		if get_node("KinematicBody2D/ResourceStore").protein > 0:
			get_node("KinematicBody2D/ResourceStore").take_protein(1)
		else:
			get_node("KinematicBody2D/ResourceStore").add_protein(1)
