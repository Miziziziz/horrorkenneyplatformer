extends CanvasLayer

var text_to_display = ""
var txt_ind = 0
var txt_display_rate = 0.02
var cur_time = 0.0
onready var text_label = $Nodes/TextPanel/Label

onready var happy_face = $Nodes/FacePanel/HappyDisplay
onready var sad_face = $Nodes/FacePanel/SadDisplay
onready var freakedout_face = $Nodes/FacePanel/FreakedOutDisplay

func display_text(txt, mood=0):
	$Nodes.show()
	cur_time = 0.0
	text_to_display = txt
	txt_ind = 0
	text_label.text = ""
	hide_faces()
	if mood == 0:
		happy_face.show()
	elif mood == 1:
		sad_face.show()
	else:
		freakedout_face.show()

func hide_display():
	$Nodes.hide()

func hide_faces():
	happy_face.hide()
	sad_face.hide()
	freakedout_face.hide()

func _process(delta):
	cur_time += delta
	while cur_time >= txt_display_rate and txt_ind < text_to_display.length():
		cur_time -= txt_display_rate
		text_label.text += text_to_display[txt_ind]
		txt_ind += 1