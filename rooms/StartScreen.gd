extends Node2D

func _ready():
	$AnimatedSprite.play()

func _on_Button_pressed():
	get_tree().change_scene("res://rooms/main.tscn")
