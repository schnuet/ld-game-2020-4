extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoPlayer.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	get_tree().change_scene("res://rooms/StartScreen.tscn")
