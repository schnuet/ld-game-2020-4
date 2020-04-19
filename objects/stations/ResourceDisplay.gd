extends Node2D

export (NodePath) var resourceStorePath;
var resourceStore;

var energy_rect_max_width = 22;
var protein_rect_max_width = 22;


func _ready():
	resourceStore = get_node(resourceStorePath);
	protein_rect_max_width = $RectProtein.rect_size.x;
	energy_rect_max_width = $RectEnergy.rect_size.x;
	updateRects();
	
func updateRects():
	updateEnergyRect();
	updateProteinRect();
	

func updateEnergyRect():
	$RectEnergy.rect_size.x = (float(resourceStore.energy) / float(resourceStore.max_energy)) * energy_rect_max_width;

func updateProteinRect():
	$RectProtein.rect_size.x = (float(resourceStore.protein) / float(resourceStore.max_protein)) * energy_rect_max_width;


# attach label changing when values change

func _on_ResourceStore_energy_amount_changed(amount):
	updateRects();

func _on_ResourceStore_max_energy_changed(amount):
	updateRects();

func _on_ResourceStore_protein_amount_changed(amount):
	updateRects();

func _on_ResourceStore_max_protein_changed(amount):
	updateRects();
