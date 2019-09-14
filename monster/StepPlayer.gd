extends AudioStreamPlayer2D

var step_sounds = [
	preload("res://sfx/monster_footsteps/gravel.ogg"),
	preload("res://sfx/monster_footsteps/leaves01.ogg"),
	preload("res://sfx/monster_footsteps/leaves02.ogg"),
	preload("res://sfx/monster_footsteps/mud02.ogg")
]

func play_step():
	stream = step_sounds[randi() % step_sounds.size()]
	play()