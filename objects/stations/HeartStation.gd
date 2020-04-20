extends "res://objects/stations/Station.gd"

export var energy_on_start:int = 5
export var time_to_energy_consumption:int = 10
export var initial_energy_consumption:int = 1
export var energy_consumption_increase_per_level:int = 1

var current_energy_consumption

signal heart_dead
signal heart_updated

# Called when the node enters the scene tree for the first time.
func _ready():
	$ResourceStore.add_energy(energy_on_start)
	$EnergyTimer.start(time_to_energy_consumption)
	current_energy_consumption = initial_energy_consumption

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func remove_energy(amount:int):
	$ResourceStore.remove_energy(amount)

func perform_update_action():
	current_energy_consumption += energy_consumption_increase_per_level
	emit_signal("heart_updated")

func _on_energy_amount_changed(energy):
	if $ResourceStore.has_energy() == false:
		print_debug("Heart is dead!")
		emit_signal("heart_dead")


func _on_EnergyTimer_timeout():
	remove_energy(current_energy_consumption)
