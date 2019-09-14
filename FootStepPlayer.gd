extends AudioStreamPlayer

var step_sounds = [
	preload("res://sfx/player_footsteps/footstep00.ogg"),
	preload("res://sfx/player_footsteps/footstep01.ogg"),
	preload("res://sfx/player_footsteps/footstep02.ogg"),
	preload("res://sfx/player_footsteps/footstep03.ogg"),
	preload("res://sfx/player_footsteps/footstep04.ogg"),
]

func play_step():
	stream = step_sounds[randi() % step_sounds.size()]
	play()