extends CollisionShape2D

export(int) var relative_ladder_top

var area_2d
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	area_2d = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Area2D_body_entered(body):
	if body.is_in_group("Minion"):
		var global_pos = global_position
		var bottom_position = Vector2(global_pos.x, global_pos.y + shape.extents.y)
		var top_position = Vector2(global_pos.x, global_pos.y - relative_ladder_top)		
		body.enter_ladder(top_position, bottom_position, area_2d.name)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Minion"):
		body.exit_ladder(area_2d.name)

