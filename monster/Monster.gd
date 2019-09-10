extends KinematicBody2D

onready var left_legs = $LeftLegs.get_children()
onready var right_legs = $RightLegs.get_children()

onready var right_ray = $RightRay
onready var left_ray = $LeftRay
onready var down_ray = $DownRay
onready var up_ray = $UpRay

var move_dir = 1 # -1 left 0 still 1 right

export var h_move_speed = 100
export var v_move_speed = 80

export var step_rate = 0.2
var step_time = 0.0
var leg_ind = 0
var step_left = false

func _ready():
	set_start_leg_positions()

func set_start_leg_positions():
	for leg in left_legs:
		var result = get_left_ray()
		if result:
			leg.set_hand_pos(result.position)
			leg.goal_pos = result.position
		leg.step_time = leg.step_rate
	for leg in right_legs:
		var result = get_right_ray()
		if result:
			leg.set_hand_pos(result.position)
			leg.goal_pos = result.position
		leg.step_time = leg.step_rate

func get_left_ray():
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, global_position + 2000 * Vector2.RIGHT.rotated(deg2rad(rand_range(95, 150))))

func get_right_ray():
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(global_position, global_position + 2000 * Vector2.RIGHT.rotated(deg2rad(rand_range(25, 50))))

func _physics_process(delta):
	var vert_dir = 0
	if down_ray.is_colliding():
		vert_dir += -1
	if up_ray.is_colliding():
		vert_dir += 1
	
	var hor_dir = move_dir
	if move_dir == 1 and right_ray.is_colliding():
		hor_dir = 0
	if move_dir == -1 and left_ray.is_colliding():
		hor_dir = 0
	
	step_time += delta
	if hor_dir != 0 and step_time >= step_rate:
		step_time = 0.0
		step_left = !step_left
		var leg = null
		var ray_result = null
		if step_left:
			leg_ind += 1
			leg_ind %= left_legs.size()
			leg = left_legs[leg_ind]
			ray_result = get_left_ray()
		else:
			leg = right_legs[leg_ind]
			ray_result = get_right_ray()
		if ray_result:
			leg.step(ray_result.position)
	
	move_and_collide(Vector2(hor_dir * h_move_speed, vert_dir * v_move_speed) * delta)
