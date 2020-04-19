extends Node2D

var energy:int = 0;
var protein:int = 0;
export var max_energy:int = 1;
export var max_protein:int = 1;

signal protein_amount_changed;
signal energy_amount_changed;

# add energy and protein

func add_energy(x:int):
	energy = min(energy + x, max_energy);
	emit_signal("energy_amount_changed", energy);
	return energy;

func add_protein(x:int):
	protein = min(protein + x, max_protein);
	emit_signal("protein_amount_changed", protein);
	return protein;


# get energy and protein

func take_energy(x:int = 1):
	if (x > energy): return 0;
	energy -= x;
	emit_signal("energy_amount_changed", energy);
	return x;

func take_protein(x:int = 1):
	if (x > protein): return 0;
	protein -= x;
	emit_signal("protein_amount_changed", protein);
	return x;
