extends Area2D

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


func _ready():
	$ResourceStore.max_energy = max_energy;
	$ResourceStore.max_protein = max_protein;
	$ResourceDisplay.updateLabels();


# worker methods

func request_worker():
	emit_signal("request_worker");

func add_worker(worker):
	assigned_workers.append(worker);


# update methods

func get_can_be_updated():
	return $ResourceStore.protein >= protein_needed_for_update;
	
func update():
	if (!can_be_updated):
		return false;
	else:
		perform_update();

func perform_update():
	$ResourceStore.take_protein(protein_needed_for_update);
	upgrade_level += 1;



# action methods

# activate action when action timer runs out:
func _on_ActionTimer_timeout():
	$ActionTimer.wait_time = action_timer_time;
	trigger_action();

# perform the action if there's enough energy for it:
func trigger_action():
	if ($ResourceStore.energy < energy_needed_for_action):
		return false;
	else:
		$ResourceStore.take_energy(energy_needed_for_action);
		perform_action();

# do the action
func perform_action():
	pass;


# add listeners for an action trigger

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
