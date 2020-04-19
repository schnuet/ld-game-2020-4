extends "res://objects/stations/Station.gd"

# Heartstation can
# 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

# energy methods
func can_add_energy():
	return !$ResourceStore.energy_is_full()
	
func add_energy(energy):
	$ResourceStore.add_energy(energy)
	
func need_energy():
	return can_add_energy()
