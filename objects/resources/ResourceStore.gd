extends Node2D

var energy:int = 0;
var protein:int = 0;
export var max_energy:int = 1;
export var max_protein:int = 1;


# add energy and protein

func add_protein(x:int):
	protein = min(protein + x, max_protein);
	return protein;

func add_energy(x:int):
	energy = min(energy + x, max_energy);
	return energy;


# get energy and protein

func take_energy(x:int = 1):
	if (x > energy): return 0;
	energy -= x;
	return x;

func take_protein(x:int = 1):
	if (x > protein): return 0;
	protein -= x;
	return x;
