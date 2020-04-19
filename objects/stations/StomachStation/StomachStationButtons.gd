extends "res://objects/stations/stationButtons/StationButtons.gd"


func _process(delta):
	if (player == null): return;
	var can_take_protein = player.get_node("ResourceStore").can_add_protein();

	$TakeProteinStationButton.visible = can_take_protein;
