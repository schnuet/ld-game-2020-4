extends Area2D

# the amount of ressources saved in the station
var energy = 0;
var protein = 0;

# limits
export var max_energy = 10;
export var max_protein = 10;

# required amounts
export var protein_needed_for_update = 10;
export var energy_needed_for_action = 0;

var assigned_workers = [];

# update
var can_be_updated setget , get_can_be_updated;
var upgrade_level = 0;

# action
var action_timer_time = 1; # in seconds

signal request_worker;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if (energy > energy_needed_for_action):
		pass


# add energy and protein

func add_protein(x):
	protein = min(protein + x, max_protein);
	return protein;

func add_energy(x):
	energy = min(energy + x, max_energy);
	return energy;


# get energy and protein

func take_energy(x = 1):
	if (x > energy): return 0;
	energy -= x;
	return x;

func take_protein(x = 1):
	if (x > protein): return 0;
	protein -= x;
	return x;



# worker methods

func request_worker():
	emit_signal("request_worker");

func add_worker(worker):
	assigned_workers.append(worker);



# update methods


func get_can_be_updated():
	return protein >= protein_needed_for_update;
	
func update():
	if (!can_be_updated):
		return false;
	else:
		perform_update();

func perform_update():
	protein -= protein_needed_for_update;
	upgrade_level += 1;



# action methods

func trigger_action():
	if (energy < energy_needed_for_action):
		return false;
	else:
		energy -= energy_needed_for_action;
		perform_action();

func perform_action():
	pass;

func _on_ActionTimer_timeout():
	$ActionTimer.wait_time = action_timer_time;
	trigger_action();
	
func add_action_trigger_listener(body, method_as_string):
	if (!is_connected("action_triggered", body, method_as_string)):
		connect("action_triggered", body, method_as_string);
		return true;
	else:
		return false;

func remove_action_trigger_listener(body, method_as_string):
	if (is_connected("action_triggered", body, method_as_string)):
		disconnect("action_triggered", body, method_as_string);
		return true;
	else:
		return false;
