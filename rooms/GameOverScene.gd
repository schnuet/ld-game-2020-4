extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoPlayer.play();
	$SecondsAliveLabel.text = str(Utils.get_count()) + " seconds";
	$SecondsAliveLabel.visible = false;
	$RestartButton.visible = false;
	
	# reset the seconds alive
	Utils.seconds_alive = 0;


func _on_VideoPlayer_finished():
	$VideoPlayer.stop();
	$SecondsAliveLabel.visible = true;
	$Timer.start(1);
	$V.visible = true;

func _process(delta):
	if (Input.is_action_pressed("trigger_action")):
		restart();

func restart():
	get_tree().change_scene("res://rooms/main.tscn");


func _on_RestartButton_pressed():
	restart();


func _on_Timer_timeout():
	$RestartButton.visible = true;
