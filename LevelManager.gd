extends Node

var level_ind = 0
var level_list = [
	"res://levels/Entrance.tscn",
	"res://levels/Simple.tscn",
	"res://levels/PushTheCrates.tscn",
	"res://levels/Sewers.tscn"
]

var delete_on_load = []

func load_next_level():
	level_ind = (level_ind+1) % level_list.size()
	load_level(level_ind)

func load_previous_level():
	level_ind = (level_ind-1) % level_list.size()
	load_level(level_ind)

func load_level(ind):
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	FanSoundManager.stop_fan()
	get_tree().change_scene(level_list[ind])
	