extends CollisionShape2D

export(int) var relative_ladder_top

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Area2D_body_entered(body):
	if body.is_in_group("Minion"):
		var bottom_position = Vector2(position.x, position.y + shape.extents.y)
		var top_position = Vector2(position.x, position.y - relative_ladder_top)
		print(bottom_position)
		print(top_position)
		body.enter_ladder(top_position, bottom_position)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Minion"):
		body.exit_ladder()
