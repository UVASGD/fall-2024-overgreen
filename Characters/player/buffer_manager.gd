# TODO: implement this with everything else

extends Node

class_name InputBufferManager

var input_buffer = []
const DEFAULT_BUFFER_TIME = 0.2 # max time (s) to store an input

func tick(delta) -> void:
	for i in range(input_buffer.size() - 1, -1, -1): # reverse loop to allow removal
		input_buffer[i].remaining_time -= delta
		if input_buffer[i].remaining_time <= 0:
			input_buffer.remove(i) # remove expired inputs

func buffer_input(input_event) -> void:
	input_buffer.append({"event": input_event, "remaining_time": DEFAULT_BUFFER_TIME})

func consume_input() -> String:
	if input_buffer.size() > 0:
		return input_buffer.pop_front()["event"]
	return ""
