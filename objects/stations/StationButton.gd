extends Area2D

signal button_action_triggered

var state = 'idle'
var is_hovered = false
var is_active = false

func _process(_delta):
	is_active = Input.is_action_pressed("trigger_action") and is_hovered

	if Input.is_action_just_pressed("trigger_action") and is_hovered:
		emit_signal("button_action_triggered")

	$Sprite.frame = 0
	if is_hovered:
		$Sprite.frame = 1
	if is_active:
		$Sprite.frame = 2

func _on_Button_body_entered(body):
	if body.name == "Player":
		is_hovered = true

func _on_Button_body_exited(body):
	if body.name == "Player":
		is_hovered = false
