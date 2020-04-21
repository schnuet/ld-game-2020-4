extends Node2D


signal change_environment_request

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_environment():
	emit_signal("change_environment_request");
