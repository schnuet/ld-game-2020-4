extends Node2D

func _ready():
	$AnimatedSprite.play()

func _on_Button_pressed():
	start()

func _process(delta):
	if (Input.is_action_pressed("trigger_action")):
		start();

func start():
	get_tree().change_scene("res://rooms/main.tscn")
