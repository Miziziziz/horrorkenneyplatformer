extends Node

var level_list = [
	"res://World.tscn"
]

func load_next_level():
	load_level(0)

func load_previous_level():
	pass

func load_level(ind):
	FanSoundManager.stop_fan()
	get_tree().change_scene(level_list[ind])
	