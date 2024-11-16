extends Node

class_name PlayerBasicMovement

signal lock_movement(lock)

var player: Player
var lock: bool

# get the gravity from the project settings to be synced with RigidBody nodes
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var velocity: Vector2
var was_in_air: bool = false
var has_double_jumped = false

func _ready():
	player = get_parent()
	var dash_node = player.get_node("PlayerDash")
	dash_node.connect("lock_movement", Callable(self, "_on_lock_signal"))
func tick(delta):
	if player == null:
		return
	if lock:
		player.move_and_slide()
		return
	# add gravity
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		was_in_air = true
	elif was_in_air:
		has_double_jumped = false
		# todo: change to signal method
		player.land()
		was_in_air = false
	# handle jump
	if Input.is_action_just_pressed("jump"):
		#if player.is_on_floor() or player.is_on_wall():
			# Normal jump from floor
		if player.is_on_floor():
			# normal jump from floor
			jump()
		elif not has_double_jumped:
			# Double jump in air
			player.velocity.y = player.double_jump_velocity
			has_double_jumped = true
	# get the input direction and handle the movement/deceleration
	# as good practice, you should replace UI actions with custom gameplay actions
	player.direction = Input.get_vector("left", "right", "up", "down")
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.x = player.direction.x * player.speed
	player.move_and_slide()
	
func get_velocity():
	return player.velocity
	
func jump():
	player.velocity.y = player.jump_velocity
	player.animated_sprite.play("jump_start")
	player.animation_handler.set_state("jump_start")

func _on_lock_signal(locked):
	lock = locked
