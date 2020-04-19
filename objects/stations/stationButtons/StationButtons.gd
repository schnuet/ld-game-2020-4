extends Area2D

# is only shown when the player is in the room

export (NodePath) var station_path;
var station:Station = null;
var player = null;

func _ready():
	visible = false;
	station = get_node(station_path);
	
func _process(delta):
	if (!visible): return;
	
	update_standard_buttons_visibility();
	

func update_standard_buttons_visibility():
	var can_add_minions = $AddMinionStationButton.enabled;
	var can_remove_minions = $RemoveMinionStationButton.enabled;
	var can_add_protein = $PutProteinStationButton.enabled;
	
	# only show the relevant actions for the current moment:
	var player_res = player.get_node("ResourceStore");
	if (player_res.protein > 0):
		can_add_minions = false;
		can_remove_minions = false;
		if not station.get_node("ResourceStore").can_add_protein:
			can_add_protein = false;
	else:
		can_add_protein = false;
	
	# check mimion counts
	if (station.assigned_workers.empty()):
		can_remove_minions = false;
	
	$AddMinionStationButton.visible = can_add_minions;
	$RemoveMinionStationButton.visible = can_remove_minions;
	$PutProteinStationButton.visible = can_add_protein;

# show the buttons when the player enters the room
func _on_StationButtons_body_entered(body):
	# only handle player
	if (body.name != "Player"): return;
	
	visible = true;
	player = body;


# hide the buttons when the player leaves the room
func _on_StationButtons_body_exited(body):
	# only handle player
	if (body.name != "Player"): return;
	
	visible = false;
	player = null;
