extends Node2D

var enemy
var speed:float
var damage:int

export var frame_to_start = 5

var current_target_pos:Vector2

var invalid = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if is_instance_valid(enemy) && invalid == false:
		current_target_pos = enemy.global_position
	else:
		invalid = true
	if $AnimatedSprite.frame > frame_to_start:
		var delta_distance = speed * delta
		global_position = global_position.move_toward(current_target_pos, delta_distance)
		if global_position.is_equal_approx(current_target_pos):
			if is_instance_valid(enemy):
				enemy.take_damage(damage)
			queue_free()
	

func init(enemy, speed:float, damage:int):
	self.enemy = enemy
	self.speed = speed
	self.damage = damage
	$AnimatedSprite.play()
