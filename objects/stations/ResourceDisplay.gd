extends Node2D

export (NodePath) var resourceStorePath;
var resourceStore;

var energy_rect_max_width = 22;
var protein_rect_max_width = 22;

var animated_protein_percent = 0;
var animated_energy_percent = 0;

var tween_duration = 0.2; #in seconds


func _ready():
	resourceStore = get_node(resourceStorePath);
	protein_rect_max_width = $RectProtein.rect_size.x;
	energy_rect_max_width = $RectEnergy.rect_size.x;
	updateRects();
	
func updateRects():
	updateEnergyRect();
	updateProteinRect();

func updateEnergyRect():
	var energy_percent = float(resourceStore.energy) / float(resourceStore.max_energy);
	$TweenEnergy.interpolate_property(self, "animated_energy_percent",
	        animated_energy_percent, energy_percent, tween_duration,
	        Tween.TRANS_LINEAR, Tween.EASE_OUT);
	$TweenEnergy.start();

func updateProteinRect():
	var protein_percent = float(resourceStore.protein) / float(resourceStore.max_protein);
	$TweenProtein.interpolate_property(self, "animated_protein_percent",
	        animated_protein_percent, protein_percent, tween_duration,
	        Tween.TRANS_LINEAR, Tween.EASE_OUT);
	$TweenProtein.start();

func _process(delta):
	$RectEnergy.rect_size.x = animated_energy_percent * energy_rect_max_width;
	$RectProtein.rect_size.x = animated_protein_percent * protein_rect_max_width;	

# attach label changing when values change

func _on_ResourceStore_energy_amount_changed(amount):
	updateRects();

func _on_ResourceStore_max_energy_changed(amount):
	updateRects();

func _on_ResourceStore_protein_amount_changed(amount):
	updateRects();

func _on_ResourceStore_max_protein_changed(amount):
	updateRects();
