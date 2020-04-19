extends KinematicBody2D

signal action_triggered

const GRAVITY = 200.0
const WALK_SPEED = 100

var velocity = Vector2()
var on_ladder = null

func enter_ladder(ladder_name):
	print("Enter ladder")
	on_ladder = ladder_name

func exit_ladder(ladder_name):
	print("Exit ladder")
	on_ladder = null if ladder_name == on_ladder else on_ladder

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

	if on_ladder != null:
		if Input.is_action_pressed("up"):
			velocity.y = -WALK_SPEED
		elif Input.is_action_pressed("down"):
			velocity.y = WALK_SPEED
		else:
			velocity.y = 0

	move_and_slide(velocity)
