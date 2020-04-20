extends Area2D

# is only shown when the player is in the room

export (NodePath) var station_path;

var station:Station = null;
var player = null;

signal player_entered
signal player_left

func _ready():
	visible = false;
	station = get_node(station_path);

func _process(delta):
	if (!visible): return;
	
	# BUILD station when in build mode and not built
	var trigger_button_pressed = Input.is_action_pressed("trigger_action");
	if (!station.active && trigger_button_pressed && station.build_mode):
		station.build();

	update_standard_buttons_visibility();


func update_standard_buttons_visibility():
	var buttons = [
		$AddMinionStationButton,
		$RemoveMinionStationButton,
		$PutProteinStationButton,
		$AddBrainTokenStationButton
	]

	# deactivate all buttons when not active
	if !station.active:
		for btn in buttons:
			btn.visible = false
		return

	var can_add_minion = $AddMinionStationButton.enabled;
	var can_remove_minion = $RemoveMinionStationButton.enabled;
	var can_add_protein = $PutProteinStationButton.enabled;
	var can_add_brain_token = $AddBrainTokenStationButton.enabled;

	# only show the relevant actions for the current moment:
	var player_res = player.get_node("ResourceStore");
	if (player_res.protein > 0):
		can_add_minion = false;
		can_remove_minion = false;
		if not station.get_node("ResourceStore").can_add_protein():
			can_add_protein = false;
	else:
		can_add_protein = false;
		
	# check minion counts
	if (station.get_assigned_minions().empty()):
		can_remove_minion = false;
	elif (not station.can_assign_minion()):
		can_add_minion = false;
	
	# no idle workers
	if (not are_idle_minions_available()):
		can_add_minion = false;
	
	if (player.has_brain_token):
		can_add_minion = false;
		can_add_protein = false;
		can_remove_minion = false;
	else:
		can_add_brain_token = false;

	$AddMinionStationButton.visible = can_add_minion;
	$RemoveMinionStationButton.visible = can_remove_minion;
	$PutProteinStationButton.visible = can_add_protein;
	$AddBrainTokenStationButton.visible = can_add_brain_token;

func are_idle_minions_available():
	var current_scene = get_tree().current_scene;
	if(current_scene.idle_minions.size() <= 0): return false;
	return true;

# show the buttons when the player enters the room
func _on_StationButtons_body_entered(body):
	# only handle player
	if (body.name != "Player"): return;
	
	if (!station.active && station.build_mode):
		station.get_node("BuildIcon").frame = 1;

	visible = true;
	player = body;
	
	emit_signal("player_entered", player);


# hide the buttons when the player leaves the room
func _on_StationButtons_body_exited(body):
	# only handle player
	if (body.name != "Player"): return;
	
	if (!station.active && station.build_mode):
		station.get_node("BuildIcon").frame = 0;

	visible = false;
	player = null;
	
	emit_signal("player_left");
