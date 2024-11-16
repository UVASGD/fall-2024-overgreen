extends Node

class_name PlayerDash

signal lock_movement(lock: bool)
signal set_anim(state: String, interupt: bool)

var player: Player

# fullness of dash bars
var dash_charges: float
var dash_default_num_charges: float
var dashing = false

var dash_speed: float
var dash_time: float

func _ready() -> void:
	player = get_parent()

func set_constants(dash_speed_in: float, dash_time_in: float, dashes_in: float) -> void:
	dash_speed = dash_speed_in
	dash_time = dash_time_in
	dash_default_num_charges = dashes_in
	dash_charges = dashes_in

# returns if player can dash
func _get_dash() -> bool:
	return dash_charges >= 1.0 && player.direction != Vector2.ZERO && !dashing

func _get_long_dash() -> bool:
	return dash_charges > 1.0 && player.direction != Vector2.ZERO && !dashing

# dash tick
func tick() -> void:
	if Input.is_action_just_pressed("dash") && _get_dash():
	# currently not implemented: dash hold for long dash
		dash()
	
	if Input.is_action_just_pressed("longdash") && _get_dash():
		longdash()
	
	if player.is_on_floor() && !dashing:
		dash_charges = dash_default_num_charges


# dash logic
func dash() -> void:
	dash_charges -= 1
	# lock movement
	emit_signal("lock_movement", true)
	# dash
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	player.velocity.x = 0
	player.velocity.y = 0
	player.velocity = direction * dash_speed
	dashing = true
	var elapsed_time: float = 0.0
	while elapsed_time < dash_time:
		await get_tree().process_frame # wait a frame
		elapsed_time += get_process_delta_time()
		player.velocity = speed_at_time(elapsed_time * 1000.0, dash_speed, player.speed, dash_time) * direction
		# regain control 30 ms before dash ends or if dashes into floor
		if dash_time - elapsed_time < 0.03 || player.is_on_floor() && elapsed_time > 0.1:
			emit_signal("lock_movement", false)
	emit_signal("lock_movement", false)
	dashing = false


func longdash():
	var initial_direction = Input.get_vector("left", "right", "up", "down")
	# lock movement
	emit_signal("lock_movement", true)
	# TODO: make this modifiable
	var slowdown: float = 0.2
	player.velocity *= slowdown
	var dash_modifier: float = 1.0
	var dash_per_second: float = 1.0
	var elapsed_time: float = 0.0
	while !Input.is_action_just_released("longdash") && dash_modifier < 2.0:
		await get_tree().process_frame
		player.velocity += Vector2(0, slowdown * ProjectSettings.get_setting("physics/2d/default_gravity") * get_physics_process_delta_time())
		elapsed_time += get_process_delta_time()
		dash_modifier = 1.0 + (roundf(elapsed_time * 10) / 10 * dash_per_second)
		print(dash_modifier)
	# dash
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		direction = initial_direction
	player.velocity.x = 0
	player.velocity.y = 0
	player.velocity = direction * dash_speed * dash_modifier
	dashing = true
	elapsed_time = 0.0
	var new_dash_time: float = dash_time * dash_modifier
	while elapsed_time < new_dash_time:
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
		player.velocity = speed_at_time(elapsed_time * 1000.0, dash_speed, player.speed, new_dash_time) * direction
		# regain control 30 ms before dash ends or if dashes into floor
		if new_dash_time - elapsed_time < 0.03 || player.is_on_floor() && elapsed_time > 0.1:
			emit_signal("lock_movement", false)
	emit_signal("lock_movement", false)
	dashing = false
	dash_charges -= dash_modifier

func speed_at_time(t: float, v0: float, vf: float, T: float) -> float:
	# calculate constants A and C based on v0 and vf
	var A: float = (v0 - vf) / 2.0
	var C: float = (v0 + vf) / 2.0

	# angular frequency ω (half cosine wave)
	var omega: float = PI / T

	# compute velocity using the cosine equation
	# https://www.desmos.com/calculator/vin4sytkdf
	var v_t = A * cos(omega * t) + C
	return v_t

# returns if character is dashing
func is_dashing():
	return dashing
