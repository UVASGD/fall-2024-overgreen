extends Node

class_name PlayerBasicMovement

var player: CharacterBody2D

# get the gravity from the project settings to be synced with RigidBody nodes
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var velocity: Vector2
var was_in_air: bool = false
var has_double_jumped: bool = false


func _init(player_node):
	player = player_node

func tick(delta):
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		if was_in_air == true:
			player.land()
		was_in_air = false
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor() or player.is_on_wall():
			# Normal jump from floor
			jump()
		elif not has_double_jumped:
			# Double jump in air
			player.velocity.y = player.double_jump_velocity
			has_double_jumped = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	player.direction = Input.get_vector("left", "right", "up", "down")
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.x = player.direction.x * player.speed
	player.move_and_slide()

func jump():
	player.velocity.y = player.jump_velocity
	player.animated_sprite.play("jump_start")
