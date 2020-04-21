extends Node

# put helper functions in here

var seconds_alive = 0;

static func filter(filter_function: FuncRef, candidate_array: Array)->Array:
    var filtered_array := []

    for candidate_value in candidate_array:
        if filter_function.call_func(candidate_value):
            filtered_array.append(candidate_value)

    return filtered_array

func count_up():
	print("alive for " + str(seconds_alive) + " seconds");
	seconds_alive += 1;

func get_count():
	return seconds_alive;
