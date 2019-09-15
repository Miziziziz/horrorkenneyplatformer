extends Node2D

export var text_to_show = ""
enum MOODS { HAPPY, SAD, FREAKED_OUT}
export(MOODS) var mood_to_show = MOODS.HAPPY

func anim_over(nm):
	TextDisplay.display_text(text_to_show, mood_to_show)

func hide_text_when_exit(coll):
	TextDisplay.hide_display()