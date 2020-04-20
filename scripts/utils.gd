extends Node

# put helper functions in here

var seconds_alive = 0;
var timer;

static func filter(filter_function: FuncRef, candidate_array: Array)->Array:
    var filtered_array := []

    for candidate_value in candidate_array:
        if filter_function.call_func(candidate_value):
            filtered_array.append(candidate_value)

    return filtered_array

func start_life_count():
	seconds_alive = 0;
	timer = Timer.new();
	timer.start(1);
	timer.connect("timeout", self, "count_up");
	
func stop_life_count():
	timer.stop();

func count_up():
	seconds_alive += 1;

func get_count():
	return seconds_alive;
