extends CharacterBody2D

class_name Player

@export var speed: float = 125.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -150.0
@export var dash_speed: float = 200;
@export var dash_time: float = 0.25;
@export var dash_num_charges: float = 2.0;

@export var nearestHook: Vector2
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Remove @onready and initialize the variables in _ready()
var animation_handler: SpriteAnimation
var dash_handler: PlayerDash
var basic_movement_handler: PlayerBasicMovement

func _ready():
	animation_handler = SpriteAnimation.new($AnimatedSprite2D)
	dash_handler = PlayerDash.new()
	dash_handler.name = "PlayerDash"
	dash_handler.set_constants(dash_speed, dash_time, dash_num_charges)
	basic_movement_handler = PlayerBasicMovement.new()
	basic_movement_handler.name = "PlayerBasicMovement"
	# add to scene tree
	add_child(dash_handler)
	add_child(basic_movement_handler)
	health_bar = get_parent().get_node("CanvasLayer").get_node("HealthBar")
	health_bar.max_value = 10  # Set max value
	health_bar.value = health_bar.max_value
	
	# Create a new Theme
	var theme = Theme.new()
	health_bar.theme = theme  # Assign the theme to the ProgressBar

	# Create a StyleBoxFlat for the fill
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color.GREEN
	fill_style.corner_radius_top_left = 10  # Set the corner radius
	fill_style.corner_radius_top_right = 10
	fill_style.corner_radius_bottom_left = 10
	fill_style.corner_radius_bottom_right = 10
	
	# Set the fill style to the ProgressBar
	theme.set_stylebox("fill", "ProgressBar", fill_style)

	# Optionally, set a background style for the ProgressBar
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.2, 0.2, 0.2)  # Darker background
	bg_style.corner_radius_top_left = 10
	bg_style.corner_radius_top_right = 10
	bg_style.corner_radius_bottom_left = 10
	bg_style.corner_radius_bottom_right = 10
	theme.set_stylebox("panel", "ProgressBar", bg_style)
	
	theta = deg_to_rad(90)
	isGrappling = false
	wasGrappling = false
	radX = 0


@onready var grapple_scene = preload("res://Characters/hook.tscn")


var hookPos: Vector2
var direction: Vector2 = Vector2.ZERO
var theta: float
var isGrappling
var wasGrappling
var radius: float = 100.0
var gravity: float = 20.0
var angAccel = 0
var angVel = 0
var t = 0
var yvel
var xvel
var swingSpeed = 20
var swingForce = 0
var radX


#func _ready():
	#theta = deg_to_rad(90)
	#isGrappling = false
	#wasGrappling = false
	#radX = 0
	


var currentHealth: float = 10
var healthDeduction: float = 0
var fallDamage: float = 0
var vel: float = 0
var recorded_velocity_y: float = 0
@onready var my_label = $Label
@onready var health_bar: ProgressBar
@onready var rng = RandomNumberGenerator.new()

enum GROUND_STATE {
	GROUNDED,
	MIDAIR,
	TOUCHDOWN
}
var player_state = GROUND_STATE.GROUNDED

	
func _physics_process(delta):
	if isGrappling == false:
		
		swingForce = 0
		basic_movement_handler.tick(delta)
		
		if is_on_floor() or is_on_wall():
			yvel = 0
			xvel = 0
			wasGrappling = false
			angVel = 0
		
		else:
			if wasGrappling:
				yvel = angVel * radius * cos(theta + (PI/2)) * delta
				xvel = -1 * angVel * radius * sin(theta + (PI/2)) * delta
				position.y += yvel
				position.x += xvel
				
	else:
		
		angAccel = ang_accel() 
		angVel += swingSpeed * angAccel * delta
		theta += angVel * delta
		
		position = Vector2(radius * cos(theta + (PI/2)), radius * sin(theta + (PI/2))) + hookPos 
		
		
		if Input.is_action_pressed("left"):
			if swingForce >= -1.00:
				swingForce -= delta
				angVel -= swingForce * delta
		if Input.is_action_pressed("right"):
			if swingForce <= 1.00:
				swingForce += 1 * delta
				angVel += swingForce * delta
		
				
		move_and_slide()
		if is_on_wall() or is_on_ceiling():
			reset(delta)
			
	#print(radius)
	#print("theta:" + str(theta))
	print("angVel:" + str(angVel))
	#print("angAccel:" + str(angAccel))
	#print(isGrappling)
	#print(wasGrappling)
	#print(swingForce)
	#print(velocity.x)
	
	if Input.is_action_just_pressed("grappling"):
		reset(delta)
		
	animation_handler.tick(direction)
	queue_redraw()
	
func land():
	animation_handler.set_state("jump_end")
	
func ang_accel() -> float:
	return -1 * (gravity/radius) * sin(theta)
	
func _draw():
	if isGrappling:
		#draw_line(Vector2(0, 0), -position + hookPos, Color.BLACK, 5.0)
		get_node("Line2D").points[1] = Vector2(-position + hookPos)
		get_node("Line2D").visible = true

func reset(delta):
	wasGrappling = isGrappling
	if position.distance_to(nearestHook) < radius || isGrappling:
		isGrappling = !isGrappling
		radius = position.distance_to(nearestHook)
		radX = position.x - nearestHook.x
		theta = -asin(radX/radius) 
		
		if !isGrappling:
			get_node("Line2D").visible = false
			radius = 100.0
	hookPos = nearestHook

	basic_movement_handler.tick(delta)
	dash_handler.tick()

func _process(_delta):
	animation_handler.tick(direction)

	animation_handler.tick(direction)
	
	var current_velocity_y = basic_movement_handler.get_velocity().y 
	
	match player_state:
		GROUND_STATE.GROUNDED:
			if not is_on_floor():
				player_state = GROUND_STATE.MIDAIR
		GROUND_STATE.MIDAIR:
			if (current_velocity_y > recorded_velocity_y):
				recorded_velocity_y = current_velocity_y  # Record the maximum velocity while in the air
			if is_on_floor():
				player_state = GROUND_STATE.TOUCHDOWN
		GROUND_STATE.TOUCHDOWN:
			apply_fall_damage(recorded_velocity_y)  # Apply damage based on recorded velocity
			recorded_velocity_y = 0 # reset value
			player_state = GROUND_STATE.GROUNDED

#func land():
	#animation_handler.set_state("jump_end")

func apply_fall_damage(velocity):

	if (velocity > 280):
		fallDamage = ((velocity - 280)/30)
		updateHealth(currentHealth - fallDamage)
	
func updateHealth(newHealth):
	currentHealth = snapped(newHealth, 0.1)
	if health_bar:
		health_bar.value = currentHealth
		update_health_bar_color()
	else:
		print ("no health bar found")
		
func update_health_bar_color():
	var health_ratio = currentHealth / health_bar.max_value
	var red = lerp(0, 1, 1.0 - health_ratio)
	var green = lerp(1, 0, 1.0 - health_ratio)
	var new_color = Color(red, green, 0)
	var fill_style = health_bar.theme.get_stylebox("fill", "ProgressBar") as StyleBoxFlat
	fill_style.bg_color = new_color
	health_bar.theme.set_stylebox("fill", "ProgressBar", fill_style)

func _on_hitbox_area_entered(area):
	#print(area.name)
	if area.name == "mob1":
		healthDeduction = randf_range(0.8, 1)
		currentHealth -= healthDeduction
	updateHealth(currentHealth)
