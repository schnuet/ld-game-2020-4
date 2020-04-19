extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	print(get_node("StationButton").is_hovered, " ", get_node("StationButton").is_active)


func _on_StationButton_button_action_triggered():
	print("Action triggered!")
