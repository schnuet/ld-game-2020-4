extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoPlayer.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	start();

func _process(delta):
	if (Input.is_action_pressed("trigger_action")):
		start();
	
func start():
	get_tree().change_scene("res://rooms/StartScreen.tscn")
