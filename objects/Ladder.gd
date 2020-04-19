extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Ladder_body_entered(body):
	if (body.name == "Player"):
		body.enter_ladder(name)

func _on_Ladder_body_exited(body):
	if (body.name == "Player"):
		body.exit_ladder(name)
