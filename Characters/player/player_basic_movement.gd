extends Node

class_name PlayerBasicMovement

signal lock_movement(lock)

var player: Player
var lock: bool

# get the gravity from the project settings to be synced with RigidBody nodes
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var velocity: Vector2
var was_in_air: bool = false

func _ready():
	player = get_parent()
	var dash_node = player.get_node("PlayerDash")
	dash_node.connect("lock_movement", Callable(self, "_on_lock_signal"))
func tick(delta):
	if lock:
		player.move_and_slide()
		return
	# add gravity
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		was_in_air = true
	elif was_in_air:
		# todo: change to signal method
		player.land()
		was_in_air = false
	# handle jump
	if Input.is_action_just_pressed("jump"):
		if player.is_on_floor():
			# normal jump from floor
			jump()
	# get the input direction and handle the movement/deceleration
	# as good practice, you should replace UI actions with custom gameplay actions
	player.direction = Input.get_vector("left", "right", "up", "down")
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.x = sign(player.direction.x) * player.speed # project vector to x axis with sign()
	player.move_and_slide()

func jump():
	player.velocity.y = player.jump_velocity
	player.animation_handler.set_state("jump_start")

func _on_lock_signal(locked):
	lock = locked