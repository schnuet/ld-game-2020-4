extends "res://objects/stations/Station.gd"

var energy_step_time setget set_energy_step_time, get_energy_step_time;
var protein_step_time setget set_protein_step_time, get_protein_step_time;


func _on_ProteinTimer_timeout():
	$ResourceStore.add_protein(1);
	
func _on_EnergyTimer_timeout():
	$ResourceStore.add_energy(1);



func get_energy_step_time():
	return $EnergyTimer.wait_time;

func set_energy_step_time(value):
	$EnergyTimer.wait_time = value;

func get_protein_step_time():
	return $ProteinTimer.wait_time;
	
func set_protein_step_time(value):
	$ProteinTimer.wait_time = value;


# listening to character enter on resource stashes

func _on_EnergyStash_body_entered(body):
	add_action_trigger_listener(body, "_on_EnergyStash_trigger");

func _on_EnergyStash_body_exited(body):
	remove_action_trigger_listener(body, "_on_EnergyStash_trigger");

func _on_ProteinStash_body_entered(body):
	add_action_trigger_listener(body, "_on_ProteinStash_trigger");

func _on_ProteinStash_body_exited(body):
	remove_action_trigger_listener(body, "_on_ProteinStash_trigger");


# activate actions:

func _on_EnergyStash_trigger(body):
	if (!$EnergyStash.visible): return false;
	
	if (body.ResourceStore.energy > 0):
		$ResourceStore.add_energy(body.ResourceStore.take_energy(1));
	else:
		var energy = $ResourceStore.take_energy(1);
		body.ResourceStore.add_energy(energy);

func _on_ProteinStash_trigger(body):
	if (!$ResourceStore.visible): return false;
	
	if (body.ResourceStore.protein > 0):
		$ResourceStore.add_protein(body.ResourceStore.take_protein(1));
	else:
		var protein = $ResourceStore.take_protein(1);
		body.ResourceStore.add_protein(protein);



# show or hide stashs if there is energy or not:

func _on_ResourceStore_energy_amount_changed(energy_amount):
	if (energy_amount > 0):
		$EnergyStash.visible = true;
	else:
		$EnergyStash.visible = false;


func _on_ResourceStore_protein_amount_changed(protein_amount):
	if (protein_amount > 0):
		$ProteinStash.visible = true;
	else:
		$ProteinStash.visible = false;
