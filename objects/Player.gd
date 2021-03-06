extends KinematicBody2D

signal action_triggered

const GRAVITY = 200.0
const WALK_SPEED = 100

var velocity = Vector2()
var on_ladder = null

var has_brain_token = false;

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

	if velocity.x != 0:
		$AnimatedSprite.play()
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.frame = 0
		$AnimatedSprite.stop()

	if Input.is_action_just_pressed("trigger_action"):
		emit_signal("action_triggered")

	if on_ladder != null:
		if Input.is_action_pressed("up"):
			velocity.y = -WALK_SPEED
		elif Input.is_action_pressed("down"):
			velocity.y = WALK_SPEED
		else:
			velocity.y = 0

	velocity = move_and_slide(velocity)

func _on_ResourceStore_energy_amount_changed(amount):
	$Energy.visible = amount > 0

func _on_ResourceStore_protein_amount_changed(amount):
	$Steak.visible = amount > 0
