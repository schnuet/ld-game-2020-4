extends Node2D

onready var empty_walk_animation = $EmptyWalkAnimation
onready var energy_walk_animation = $EnergyWalkAnimation

var active_animation:AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_visualization(movement_dir:int, energy_count:int):	
	_activate_needed_animation(energy_count)
		
	if movement_dir == 0:
		active_animation.stop()
		active_animation.frame = 0
	else:
		if movement_dir == -1:
			active_animation.flip_h = true
		else:
			active_animation.flip_h = false
		active_animation.play()


func _activate_needed_animation(energy_count:int):
	if energy_count> 0:
		active_animation = energy_walk_animation
		empty_walk_animation.visible = false
		energy_walk_animation.visible = true
	else:
		active_animation = empty_walk_animation
		empty_walk_animation.visible = true
		energy_walk_animation.visible = false
