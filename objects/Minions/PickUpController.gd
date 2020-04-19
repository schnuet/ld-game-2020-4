extends Node2D

onready var minion = $MinionController
onready var resource_store = $ResourceStore
var nav2D:Navigation2D
var god

var energy_source

var collecting_energy:bool = false
var current_energy_station

enum CollectingState {
	GoingToSource,
	AtSource,
	GoingBack,
	AtTarget,
	Idle
}

var current_state = CollectingState.Idle
var assigned_station

func enter_ladder(top_pos, bottom_pos, id):
	minion.enter_ladder(top_pos, bottom_pos, id)

func exit_ladder(id):
	minion.exit_ladder(id)

func set_navigation_2d(nav2d):
	$MinionController.nav2D = nav2d

func go_to_position(position:Vector2):
	minion.move_to_pos(position)
	assigned_station = null
	current_state = CollectingState.Idle
	# empty pockets when going to random position
	$ResourceStore.take_energy()

func assign_to_station(station):
	print("Minion assigned to ", station, " with god ", god)
	assigned_station = station
	current_state = CollectingState.GoingBack
	_go_back()

func go_collecting_energy():
	energy_source = god.get_energy_station()
	
	go_to_position(energy_source.get_position_for_minions())
	current_state = CollectingState.GoingToSource

func _physics_process(delta):
	if current_state == CollectingState.AtSource:
		_collect_energy_if_available()
	elif current_state == CollectingState.AtTarget:
		_put_energy_in_station_if_not_full()
	
	if current_state == CollectingState.Idle && assigned_station != null:
		if assigned_station.need_energy():
			go_collecting_energy()
	
func _on_MinionController_target_pos_reached():
	if current_state == CollectingState.GoingToSource:
		current_state = CollectingState.AtSource
		_collect_energy_if_available()		
	elif current_state == CollectingState.GoingBack:
		current_state = CollectingState.AtTarget
		_put_energy_in_station_if_not_full()

func _collect_energy_if_available():
	if current_energy_station != null:
		if current_energy_station.has_energy():
			_collect_energy()
			_go_back()
			
func _collect_energy():	
	var energy = current_energy_station.take_energy()
	resource_store.add_energy(energy)
		
func _go_back():
	current_state = CollectingState.GoingBack
	go_to_position(assigned_station.get_position_for_minions)

func _put_energy_in_station_if_not_full():
	if assigned_station.can_add_energy():
			_put_energy_in_station()

func _put_energy_in_station():
	current_state = CollectingState.Idle
	var energy = $ResourceStore.take_energy()
	assigned_station.add_energy(energy)
