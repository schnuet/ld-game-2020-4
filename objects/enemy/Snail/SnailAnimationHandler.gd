extends Node2D

onready var active_animation = $WalkAnimation


func update_visualization(movement_dir:int):	
		
	if movement_dir == 0:
		active_animation.stop()
		active_animation.frame = 0
	else:
		if movement_dir == -1:
			active_animation.flip_h = false
		else:
			active_animation.flip_h = true		
		active_animation.play()

