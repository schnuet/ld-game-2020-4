extends Node2D

export var energy:int = 0;
export var protein:int = 0;
export var max_energy:int = 1;
export var max_protein:int = 1;

signal protein_amount_changed;
signal energy_amount_changed;
signal max_protein_changed;
signal max_energy_changed;

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


# set max

func set_max_energy(amount):
	max_energy = amount;
	emit_signal("max_energy_changed", amount);

func set_max_protein(amount):
	max_protein = amount;
	emit_signal("max_protein_changed", amount);

func has_energy():
	return energy > 0

func can_add_protein():
	return protein < max_protein;

func can_add_energy():
	return energy < max_energy

func protein_is_full():
	return protein >= max_protein;

func energy_is_full():
	return energy >= max_energy
