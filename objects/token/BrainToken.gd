extends Area2D


var active = false;

var player = null;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if not active: 
		return;

	var input_pressed = Input.is_action_pressed("trigger_action");
	if (input_pressed):
		player.has_brain_token = true;
		active = false;
		player = null;
		queue_free();


func _on_BrainToken_body_entered(body):
	if (body.name == "Player"):
		player = body;
		active = true;



func _on_BrainToken_body_exited(body):
	if (body.name == "Player"):
		player = null;
		active = false;
