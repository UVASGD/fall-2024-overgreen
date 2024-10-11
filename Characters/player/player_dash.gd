extends Node

class_name PlayerDash

signal lock_movement(lock)

var player: Player
var anim: SpriteAnimation

# fullness of dash bars
var dash_charges: float
var dash_default_num_charges: float
var dashing = false

var dash_speed: float
var dash_time: float

func _ready():
	player = get_parent()

func set_constants(dash_speed_in, dash_time_in, dashes_in):
	dash_speed = dash_speed_in
	dash_time = dash_time_in
	dash_default_num_charges = dashes_in
	dash_charges = dashes_in

# returns if player can dash
func _get_dash():
	return dash_charges >= 1.0

# dash tick
func tick():
	if Input.is_action_just_pressed("dash"):
		# currently not implemented: dash hold for long dash
		if _get_dash():
			dash()
	
	if player.is_on_floor():
		dash_charges = dash_default_num_charges


# dash logic
func dash():
	dash_charges -= 1
	# lock movement
	emit_signal("lock_movement", true)
	# dash
	var direction = Input.get_vector("left", "right", "up", "down")
	player.velocity.x = 0
	player.velocity.y = 0
	player.velocity = direction * dash_speed
	dashing = true
	var elapsed_time = 0.0
	while elapsed_time < dash_time and not player.is_on_floor():
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
	dashing = false
	emit_signal("lock_movement", false)


# returns if character is dashing
func is_dashing():
	return dashing
