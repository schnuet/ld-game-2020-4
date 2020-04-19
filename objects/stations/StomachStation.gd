extends "res://objects/stations/Station.gd"

var energy_step_time setget set_energy_step_time, get_energy_step_time;
var protein_step_time setget set_protein_step_time, get_protein_step_time;


signal player_requested_protein;


# add resource to player

func _on_GetProteinStationButton_button_action_triggered():
	emit_signal("player_requested_protein");


# move protein to another object
func transfer_protein(body, amount = 1):
	var protein_taken = $ResourceStore.take_protein(amount);
	if (protein_taken):
		body.get_node("ResourceStore").add_protein(protein_taken);


# add resources on timeout

func _on_ProteinTimer_timeout():
	$ResourceStore.add_protein(1);
	
func _on_EnergyTimer_timeout():
	$ResourceStore.add_energy(1);



# getters and setters for step time

func get_energy_step_time():
	return $EnergyTimer.wait_time;

func set_energy_step_time(value):
	$EnergyTimer.wait_time = value;

func get_protein_step_time():
	return $ProteinTimer.wait_time;
	
func set_protein_step_time(value):
	$ProteinTimer.wait_time = value;
