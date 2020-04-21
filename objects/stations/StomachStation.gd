extends "res://objects/stations/Station.gd"

var energy_step_time setget set_energy_step_time, get_energy_step_time;
var protein_step_time setget set_protein_step_time, get_protein_step_time;


signal player_requested_protein;

signal eating_started

export var efficiency_timer_minimum = 1;
export var efficiency_timer_maximum = 5;
export var energy_handicap_duration = 60;

var energy_per_eating


#func _process(delta):
	#print(str($EnergyTimer.wait_time));


# add resource to player
func _on_TakeProteinStationButton_button_action_triggered():
	emit_signal("player_requested_protein");


# add resources on timeout

func _on_ProteinTimer_timeout():
	if ($ResourceStore.protein >= $ResourceStore.max_protein):
		$RoomMachine.playing = false;
	else: 
		$RoomMachine.playing = true;
	$ResourceStore.add_protein(1);
	
	
func _on_EnergyTimer_timeout():
	eat();

func eat():
	$ResourceStore.add_energy(1);
	emit_signal("eating_started");
	$EnergyTimer.start();

# food efficiency decreases steadily.
func reset_food_efficiency():
	$EfficiencyTween.stop_all();
	$EfficiencyTween.interpolate_property(
		$EnergyTimer,
		"wait_time", efficiency_timer_minimum,
		efficiency_timer_maximum, energy_handicap_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN);
	$EfficiencyTween.start();
	eat();
	print("reset food efficiency");


func update():
	.update()
	efficiency_timer_minimum *= 0.9;
	efficiency_timer_maximum *= 0.95;


# getters and setters for step time

func get_energy_step_time():
	return $EnergyTimer.wait_time;

func set_energy_step_time(value):
	$EnergyTimer.wait_time = value;

func get_protein_step_time():
	return $ProteinTimer.wait_time;
	
func set_protein_step_time(value):
	$ProteinTimer.wait_time = value;


func has_energy():
	return $ResourceStore.has_energy()
	
func take_energy():
	return $ResourceStore.take_energy()
