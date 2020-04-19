extends "res://objects/stations/Station.gd"

var protein_created_on_action = 1;
var energy_created_on_action = 1;

# performed on each action tick:
func perform_action():
	$ResourceStore.add_protein(protein_created_on_action);
	$ResourceStore.add_energy(energy_created_on_action);



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
	var energy = $ResourceStore.take_energy(1);
	body.ResourceStore.add_energy(energy);

func _on_ProteinStash_trigger(body):
	if (!$ResourceStore.visible): return false;
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
