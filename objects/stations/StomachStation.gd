extends "res://objects/stations/Station.gd"

var protein_created_on_action = 1;
var energy_created_on_action = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func perform_action():
	add_protein(protein_created_on_action);
	add_energy(energy_created_on_action);
