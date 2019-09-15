extends Area2D

export var one_shot = true
var has_triggered = false
signal player_entered
func _ready():
	connect("body_entered", self, "detect_player")

func detect_player(coll):
	if coll.name == "Player" and !has_triggered or !one_shot:
		has_triggered = true
		emit_signal("player_entered")

