extends Node2D

onready var minion = $MinionController
onready var resource_store = $ResourceStore
onready var animation_handler = $AnimationHandler
var nav2D:Navigation2D

var target_station:Vector2

var collecting_energy:bool = false
var current_energy_station

enum CollectingState {
	GoingToSource,
	AtSource,
	GoingBack,
	Idle
}

var current_state = CollectingState.Idle

# Called when the node enters the scene tree for the first time.
func _ready():
	minion.nav2D = nav2D
	minion.resource_store = resource_store
	minion.animation_handler = animation_handler

func go_to_station(position:Vector2):
	

func collect_energy(target:Vector2, energy_source:Vector2):
	collecting_energy = true
	target_station = target
	minion.move_to_pos(energy_source)
	current_state = CollectingState.GoingToSource

func enter_energy_source(resource_store):
	current_energy_station = resource_store
	
func exit_energy_source():
	current_energy_station = null

func _on_MinionController_target_pos_reached():
	current_state = CollectingState.AtSource
	_collect_energy()
	_go_back_if_energy_collected()

func _

func _collect_energy():
	if current_energy_station != null:
		if current_energy_station.has_energy():
			var energy = current_energy_station.take_energy()
			resource_store.add_energy(energy)
			
func _go_back_if_energy_collected():
	if resource_store.has_energy():
		_go_back()
		
func _go_back():
	current_state = CollectingState.GoingBack
	minion.move_to_pos(target_station)
