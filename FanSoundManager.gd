extends AudioStreamPlayer

var start_sound = preload("res://sfx/whir_start.wav")
var loop_sound = preload("res://sfx/whir_loop.wav")
var stop_sound = preload("res://sfx/whir_stop.wav")

var fan_running = false

var toggle_after_time = 5.0
var cur_time = 0.0
var dont_toggle = false

func start_fan():
	fan_running = true
	cur_time = 0.0
	if !playing:
		play()
	dont_toggle = false

func stop_fan():
	fan_running = false
	stream = stop_sound
	play()

func _process(delta):
	cur_time += delta
	if cur_time >= toggle_after_time and !dont_toggle:
		cur_time = 0.0
		fan_running = !fan_running
	
	if fan_running:
		if stream == start_sound and !playing:
			stream = loop_sound
			play()
		if stream == stop_sound and !playing:
			stream = start_sound
			play()
	else:
		if (stream == start_sound and !playing) or stream == loop_sound:
			stream = stop_sound
			play()

func is_safe_to_move():
	return playing