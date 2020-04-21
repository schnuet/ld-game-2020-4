extends Node2D

var chew_passes = 0;
var max_chew_passes = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"fressen":
			$AnimatedSprite.animation = "kauen";
			chew_passes = 0;
		"kauen":
			chew_passes += 1;
			if (chew_passes >= max_chew_passes):
				$AnimatedSprite.animation = "schlucken";
		"schlucken":
			$AnimatedSprite.animation = "idle";
		
			
			


func _on_StomachStation_eating_started():
	if $AnimatedSprite.animation == "idle":
		$AnimatedSprite.animation = "fressen"
