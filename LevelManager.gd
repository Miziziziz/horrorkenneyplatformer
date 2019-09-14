extends Node

var level_list = [
	"res://World.tscn"
]

func load_next_level():
	get_tree().change_scene(level_list[0])

func load_previous_level():
	pass