extends KinematicBody2D

onready var left_legs = $LeftLegs.get_children()
onready var right_legs = $RightLegs.get_children()

onready var right_ray = $RightRay
onready var left_ray = $LeftRay
onready var down_ray = $DownRay
onready var up_ray = $UpRay

export var h_sprint_move_speed = 200
export var v_sprint_move_speed = 160
export var h_walk_move_speed = 100
export var v_walk_move_speed = 80

export var walk_step_rate = 0.2
export var sprint_step_rate = 0.1
export var sprinting = false
var step_time = 0.0
var leg_ind = 0
var step_left = false

enum TRAVEL_DIR {UP, DOWN, LEFT, RIGHT}
export var cur_travel_dir = TRAVEL_DIR.RIGHT

var player = null

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
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

var leg_rot_range = Vector2(-10, 10)
func get_left_ray():
	var space_state = get_world_2d().direct_space_state
	var base_r = 120
	if cur_travel_dir == TRAVEL_DIR.LEFT:
		base_r = 150
	return space_state.intersect_ray(global_position, global_position + 2000 * Vector2.RIGHT.rotated(deg2rad(base_r + rand_range(leg_rot_range.x, leg_rot_range.y))), [], collision_mask)

func get_right_ray():
	var space_state = get_world_2d().direct_space_state
	var base_r = 40
	if cur_travel_dir == TRAVEL_DIR.LEFT:
		base_r = 60
	return space_state.intersect_ray(global_position, global_position + 2000 * Vector2.RIGHT.rotated(deg2rad(base_r + rand_range(leg_rot_range.x, leg_rot_range.y))), [], collision_mask)

func _physics_process(delta):
	var move_vec = Vector2()
	
	if cur_travel_dir == TRAVEL_DIR.RIGHT:
		if right_ray.is_colliding():
			if !up_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.UP
			elif !down_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.DOWN
			else:
				cur_travel_dir = TRAVEL_DIR.LEFT
		else:
			move_vec = Vector2.RIGHT
		
	elif cur_travel_dir == TRAVEL_DIR.LEFT:
		if left_ray.is_colliding():
			if !up_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.UP
			elif !down_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.DOWN
			else:
				cur_travel_dir = TRAVEL_DIR.RIGHT
		else:
			move_vec = Vector2.LEFT
		
	elif cur_travel_dir == TRAVEL_DIR.DOWN:
		if down_ray.is_colliding():
			if !right_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.RIGHT
			elif !left_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.LEFT
			else:
				cur_travel_dir = TRAVEL_DIR.DOWN
		else:
			move_vec = Vector2.DOWN
		
	elif cur_travel_dir == TRAVEL_DIR.UP:
		if up_ray.is_colliding():
			if !right_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.RIGHT
			elif !left_ray.is_colliding():
				cur_travel_dir = TRAVEL_DIR.LEFT
			else:
				cur_travel_dir = TRAVEL_DIR.DOWN
		else:
			move_vec = Vector2.UP
	
	if cur_travel_dir == TRAVEL_DIR.RIGHT or cur_travel_dir == TRAVEL_DIR.LEFT:
		var vert_cast_to = down_ray.cast_to.y
		if !down_ray.is_colliding():
			move_vec.y = 0.2
		elif down_ray.is_colliding() and vert_cast_to * 0.9 > global_position.distance_to(down_ray.get_collision_point()):
			move_vec.y = -0.2
	
	step_time += delta
	var step_rate = walk_step_rate
	var h_move_speed = h_walk_move_speed
	var v_move_speed = v_walk_move_speed
	if sprinting:
		step_rate = sprint_step_rate
		h_move_speed = h_sprint_move_speed
		v_move_speed = v_sprint_move_speed
	if (cur_travel_dir == TRAVEL_DIR.UP or cur_travel_dir == TRAVEL_DIR.DOWN or move_vec.x != 0) and step_time >= step_rate:
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
		
		if ray_result and (!player_in_range() or player.dead):
			leg.step(ray_result.position)
		else:
			if (step_left and move_vec.x < 0) or (!step_left and move_vec.x > 0):
				leg.attack(player)
			
	move_and_collide(move_vec * Vector2(h_move_speed, v_move_speed) * delta)


func player_in_range():
	var space_state = get_world_2d().direct_space_state
	if global_position.distance_to(player.global_position) > 450:
		return false
	var result = space_state.intersect_ray(global_position, player.global_position , [], collision_mask)
	if result:
		return false
	return true
