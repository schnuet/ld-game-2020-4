extends KinematicBody2D

signal action_triggered

const GRAVITY = 200.0
const WALK_SPEED = 100

var velocity = Vector2()
var is_on_ladder = false

func enter_ladder():
	print("Enter ladder")
	is_on_ladder = true
	
func exit_ladder():
	print("Exit ladder")
	is_on_ladder = false

func _physics_process(delta):
	velocity.y += delta * GRAVITY

	if Input.is_action_pressed("left"):
		velocity.x = -WALK_SPEED
	elif Input.is_action_pressed("right"):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("trigger_action"):
		emit_signal("action_triggered")

	if is_on_ladder:
		if Input.is_action_pressed("up"):
			velocity.y = -WALK_SPEED
		elif Input.is_action_pressed("down"):
			velocity.y = WALK_SPEED
		else:
			velocity.y = 0

	move_and_slide(velocity)
