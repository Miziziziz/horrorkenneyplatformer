extends Area2D

var monster = preload("res://monster/Monster.tscn")

func _ready():
	FanSoundManager.dont_toggle = true
	connect("body_entered", self, "turn_on_fan")

func turn_on_fan(coll):
	if coll.name == "Player":
		FanSoundManager.stop_fan()
		FanSoundManager.dont_toggle = true
		var m = monster.instance()
		get_tree().get_root().add_child(m)
		m.global_position = $SpawnPoint.global_position
		LevelManager.delete_on_load.append(m)

