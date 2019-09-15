extends Area2D

var switched = false

signal activated

func use():
	if !switched:
		switched = true
		$LeverLeft.hide()
		$LeverRight.show()
		emit_signal("activated")
		$AudioStreamPlayer.play()