extends Area2D

class_name Station

# limits
export var max_energy = 10;
export var max_protein = 3;

# required amounts
export var protein_needed_for_update = 3;
export var energy_needed_for_action = 10;

export var max_minions = 2;

export var do_action_automatically = true;

# update
var can_be_updated setget ,get_can_be_updated;
var upgrade_level = 0;

# action
var action_timer_time = 1; # in seconds

signal worker_requested;
signal worker_removed;
signal station_protein_requested;
signal station_brain_token_requested;

var boost_by_lung = 1.0;
var has_brain_token = false;



func _ready():
	$ResourceStore.max_energy = max_energy;
	$ResourceStore.max_protein = max_protein;
	$ResourceDisplay.updateRects();

	# connect the station buttons to the trigger events
	$StationButtons/AddMinionStationButton.connect("button_action_triggered", self, "request_worker")
	$StationButtons/RemoveMinionStationButton.connect("button_action_triggered", self, "remove_worker")
	$StationButtons/PutProteinStationButton.connect("button_action_triggered", self, "add_protein")
	$StationButtons/AddBrainTokenStationButton.connect("button_action_triggered", self, "request_brain_token")


# worker methods

func request_worker():
	if (can_assign_minion()):
		emit_signal("worker_requested", self);

func remove_worker():
	if (get_assigned_minions().size() > 0):
		emit_signal("worker_removed", self)


# protein movement signals

func add_protein():
	emit_signal("station_protein_requested", self);

func request_brain_token():
	emit_signal("station_brain_token_requested", self);
	
func add_brain_token():
	has_brain_token = true;
	# let the brain token boost the station for 5 seconds
	$BrainTokenResetTimer.start(5);
	$ConcentrationIndicator.visible = true;



# update methods

func get_can_be_updated():
	return $ResourceStore.protein >= protein_needed_for_update;

func update():
	if (!get_can_be_updated()):
		return false;
	print("performing station update");
	$ResourceStore.take_protein(protein_needed_for_update);

	upgrade_level += 1;
	max_minions += 1;
	protein_needed_for_update *= 2;
	$ResourceStore.set_max_protein(protein_needed_for_update);
	$ResourceStore.set_max_energy(floor($ResourceStore.max_energy * 1.5));
	$ActionTimer.wait_time *= 0.8;

# listen for protein change: update if full
func _on_ResourceStore_protein_amount_changed(amount):
	if (get_can_be_updated()):
		print("starting station update");
		update();
	else:
		return false;

func change_animation_to_level(level:int):
	if (level == 1):
		$RoomMachine.animation = "level2";
	elif (level >= 2):
		$RoomMachine.animation = "level3";




# action methods

# activate action when action timer runs out:
func _on_ActionTimer_timeout():
	var new_action_wait_timer = action_timer_time * boost_by_lung;
	if (has_brain_token):
		new_action_wait_timer *= 0.5;
	# set action timer time
	$ActionTimer.wait_time = new_action_wait_timer;
	
	
	if (do_action_automatically):
		trigger_action();

# perform the action if there's enough energy for it:
func trigger_action():
	if (can_do_action()):
		$ResourceStore.take_energy(energy_needed_for_action);
		perform_action();

func can_do_action():
	if ($ResourceStore.energy < energy_needed_for_action):
		return false;
	else:
		return true;

# do the action
func perform_action():
	pass;


# protein methods

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



# minion functions

func get_position_for_minions():
	return $MinionPosition.global_position;

func get_assigned_minions():
	var all_minions = get_tree().get_nodes_in_group("Minion");
	var filter_function = funcref(self, "is_minion_assigned_here");
	var filtered_minions = Utils.filter(filter_function, all_minions);
	return filtered_minions;

func is_minion_assigned_here(minion):
	var station = minion.assigned_station;
	if (station != null):
		return station == self;
	return false;

func can_assign_minion():
	return get_assigned_minions().size() < max_minions;

func on_minion_assigned(minion):
	$ResourceDisplay.update_worker_count();

func on_minion_removed(minion):
	$ResourceDisplay.update_worker_count();




# energy methods

func can_add_energy():
	return !$ResourceStore.energy_is_full()

	
func need_energy():
	return can_add_energy()

func add_energy(energy):
	$ResourceStore.add_energy(energy)


func _on_Station_body_entered(body):
	if body.name == "Player":
		$Tween.stop_all()
		$Tween.interpolate_property($MusicPlayer, "volume_db", -80, 0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()

func _on_Station_body_exited(body):
	if body.name == "Player":
		$Tween.stop_all()
		$Tween.interpolate_property($MusicPlayer, "volume_db", 0, -80, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()


func _on_BrainTokenResetTimer_timeout():
	has_brain_token = false;
	$ConcentrationIndicator.visible = false;
