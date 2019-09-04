extends KinematicBody2D

export var move_speed = 150
export var jump_force = 250
export var grav_force = 500

export var push_force = 5

var y_velo = 0.0
var facing_right = true

onready var anim = $AnimatedSprite

func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _physics_process(delta):
	var move_dir = 0.0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	
	y_velo += grav_force * delta
	var r = move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2.UP, false, 4, 0.785398, false)
	
	#push object
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider is RigidBody2D:
			collision.collider.apply_central_impulse(-collision.normal * push_force)
	
	var grounded = is_on_floor()
	
	if r.y == 0.0 and !grounded:
		y_velo = 0.0
	
	if grounded and Input.is_action_just_pressed("jump"):
		y_velo = -jump_force
	if grounded and y_velo > 0:
		y_velo = 0.1
	
	if grounded:
		if move_dir == 0.0:
			play_anim("stand")
		else:
			play_anim("walk")
	else:
		play_anim("jump")

	if move_dir > 0 and !facing_right:
		flip()
	elif move_dir < 0 and facing_right:
		flip()

func play_anim(nm):
	if anim.animation == nm:
		return
	anim.play(nm)

func flip():
	facing_right = !facing_right
	anim.flip_h = !anim.flip_h
	