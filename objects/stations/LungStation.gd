extends "res://objects/stations/Station.gd";


signal request_station_boost_add;
signal request_station_boost_remove;

export var boost_duration = 1.0; # how many seconds are the rooms boosted?
export var boost_multiplicator = 1.25; # higher is better

func update():
	.update();
	boost_duration *= 3;
	boost_multiplicator *= 1.25;

func perform_action():
	start_boosting();
	$BoostTimer.start(boost_duration);

func start_boosting():
	for station in get_all_stations():
		station.boost_by_lung = 1 / boost_multiplicator;
		station.get_node("BoostIndicator").visible = true;
	start_boosting_animation();

func stop_boosting():
	for station in get_all_stations():
		station.boost_by_lung = 1;
		station.get_node("BoostIndicator").visible = false;
	stop_boosting_animation();


func _on_BoostTimer_timeout():
	stop_boosting();

func get_all_stations():
	return get_tree().get_nodes_in_group("Station");
	
	
func start_boosting_animation():
	$RoomMachine.playing = true;

func stop_boosting_animation():
	$RoomMachine.playing = false;
