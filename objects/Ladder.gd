extends CollisionShape2D

export(int) var relative_ladder_top

var area_2d


# Called when the node enters the scene tree for the first time.
func _ready():
	area_2d = get_parent()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Minion") || body.is_in_group("Enemy"):
		var global_pos = global_position
		var bottom_position = Vector2(global_pos.x, global_pos.y + shape.extents.y)
		var top_position = Vector2(global_pos.x, global_pos.y - relative_ladder_top)
		body.enter_ladder(top_position, bottom_position, area_2d.name)
	elif (body.name == "Player"):
		body.enter_ladder(name)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Minion") || body.is_in_group("Enemy"):
		body.exit_ladder(area_2d.name)
	elif (body.name == "Player"):
		body.exit_ladder(name)

func _on_Ladder_body_entered(body):
	if (body.name == "Player"):
		body.enter_ladder(name)

func _on_Ladder_body_exited(body):
	if (body.name == "Player"):
		body.exit_ladder(name)
