extends Node

var level_ind = 0
var level_list = [
	"res://levels/Intro.tscn",
	"res://levels/Entrance.tscn",
	"res://levels/Simple.tscn",
	"res://levels/PushTheCrates.tscn",
	"res://levels/Sewers.tscn",
	"res://levels/Finale.tscn",
	"res://levels/EndScreen.tscn"
]

var delete_on_load = []

func load_next_level():
	level_ind = (level_ind+1) % level_list.size()
	load_level(level_ind)

func load_previous_level():
	level_ind = (level_ind-1) % level_list.size()
	load_level(level_ind)

func restart_level():
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	FanSoundManager.stop_fan()
	get_tree().reload_current_scene()

func load_level(ind):
	for d in delete_on_load:
		d.queue_free()
	delete_on_load = []
	FanSoundManager.stop_fan()
	get_tree().change_scene(level_list[ind])
	