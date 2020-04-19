extends Area2D

class_name Station

# limits
export var max_energy = 10;
export var max_protein = 10;

# required amounts
export var protein_needed_for_update = 10;
export var energy_needed_for_action = 0;

var assigned_workers = [];
export var max_minions = 2;

# update
var can_be_updated setget ,get_can_be_updated;
var upgrade_level = 0;

# action
var action_timer_time = 1; # in seconds

signal worker_requested;
signal worker_removed;
signal station_protein_requested;

func _ready():
	$ResourceStore.max_energy = max_energy;
	$ResourceStore.max_protein = max_protein;
	$ResourceDisplay.updateRects();
	$StationButtons/AddMinionStationButton.connect("button_action_triggered", self, "request_worker")
	$StationButtons/RemoveMinionStationButton.connect("button_action_triggered", self, "remove_worker")
	$StationButtons/PutProteinStationButton.connect("button_action_triggered", self, "add_protein")


# worker methods

func request_worker():
	emit_signal("worker_requested", self);

func remove_worker():
	emit_signal("worker_removed", self)

func add_worker(worker):
	assigned_workers.append(worker);


# protein movement signals

func add_protein():
	emit_signal("station_protein_requested", self);

# update methods

func get_can_be_updated():
	return $ResourceStore.protein >= protein_needed_for_update;

func update():
	if (!get_can_be_updated()):
		return false;
	else:
		perform_update();

func perform_update():
	print("performing station update");
	$ResourceStore.take_protein(protein_needed_for_update);
	upgrade_level += 1;
	protein_needed_for_update *= 2;
	$ResourceStore.set_max_protein(protein_needed_for_update);
	$ResourceStore.set_max_energy(floor($ResourceStore.max_energy * 1.5));
	$ActionTimer.wait_time *= 0.8;


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



# move protein to another object
func give_protein_to(body, amount = 1):
	var protein_taken = $ResourceStore.take_protein(amount);
	if (protein_taken):
		body.get_node("ResourceStore").add_protein(protein_taken);

# get protein from another object
func receive_protein_from(body, amount = 1):
	var protein_taken = body.get_node("ResourceStore").take_protein(amount);
	if (protein_taken):
		$ResourceStore.add_protein(protein_taken);


# listen for resource update readyness
func _on_ResourceStore_protein_amount_changed(amount):
	if (get_can_be_updated()):
		print("starting station update");
		update();
	else:
		return false;

func remove_action_trigger_listener(body, method_as_string):
	if (is_connected("action_triggered", body, method_as_string)):
		disconnect("action_triggered", body, method_as_string);
		return true;
	else:
		return false;


func get_position_for_minions():
	return $MinionPosition.global_position
