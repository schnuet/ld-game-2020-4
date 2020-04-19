extends "res://objects/stations/Station.gd"

var protein_created_on_action = 1;
var energy_created_on_action = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func perform_action():
	add_protein(protein_created_on_action);
	add_energy(energy_created_on_action);



# listening to character enter

func _on_EnergyStash_body_entered(body):
	add_action_trigger_listener(body, "_on_EnergyStash_trigger");

func _on_EnergyStash_body_exited(body):
	remove_action_trigger_listener(body, "_on_ProteinStash_trigger");

func _on_ProteinStash_body_entered(body):
	add_action_trigger_listener(body, "_on_ProteinStash_trigger");

func _on_ProteinStash_body_exited(body):
	remove_action_trigger_listener(body, "_on_ProteinStash_trigger");


# activate actions:

func _on_EnergyStash_trigger(body):
	var energy = take_energy(1);
	body.add_energy(energy);

func _on_ProteinStash_trigger(body):
	var energy = take_protein(1);
	body.add_protein(protein);

