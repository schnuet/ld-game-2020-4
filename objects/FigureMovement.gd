extends KinematicBody2D

export (int) var speed = 200
const GRAVITY = 9.81

var velocity = Vector2()

func get_input():
	velocity
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1	
	velocity = velocity.normalized() * speed

func _physics_process(delta):	
	
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1	
	
	
	velocity = move_and_slide(velocity)
