extends Area2D

# is only shown when the player is in the room


func _ready():
	visible = false;

func _on_StationButtons_body_entered(body):
	if (body.name == "Player"):
		visible = true;


func _on_StationButtons_body_exited(body):
	if (body.name == "Player"):
		visible = false;
