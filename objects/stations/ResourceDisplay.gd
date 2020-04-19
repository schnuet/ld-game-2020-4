extends Node2D

export (NodePath) var resourceStorePath;
var resourceStore;

func _ready():
	resourceStore = get_node(resourceStorePath);
	updateLabels();
	
func updateLabels():
	updateEnergyLabel(resourceStore.energy);
	updateMaxEnergyLabel(resourceStore.max_energy);
	updateProteinLabel(resourceStore.protein);
	updateMaxProteinLabel(resourceStore.max_protein);

# update labels

func updateEnergyLabel(amount):
	$EnergyLabel.text = str(amount);
	
func updateMaxEnergyLabel(amount):
	$MaxEnergyLabel.text = "/" + str(amount) + " Energy";

func updateProteinLabel(amount):
	$ProteinLabel.text = str(amount);
	
func updateMaxProteinLabel(amount):
	$MaxProteinLabel.text = "/" + str(amount) + " Protein";


# attach label changing when values change

func _on_ResourceStore_energy_amount_changed(amount):
	updateEnergyLabel(amount);

func _on_ResourceStore_max_energy_changed(amount):
	updateMaxEnergyLabel(amount);

func _on_ResourceStore_protein_amount_changed(amount):
	updateProteinLabel(amount);

func _on_ResourceStore_max_protein_changed(amount):
	updateMaxProteinLabel(amount);
