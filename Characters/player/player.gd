extends CharacterBody2D

@export var speed: float = 125.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var dash_handler: PlayerDash = PlayerDash.new(self)
@onready var basic_movement_handler: PlayerBasicMovement = PlayerBasicMovement.new(self)
@onready var animation_handler: SpriteAnimation = SpriteAnimation.new(animated_sprite)

var direction: Vector2 = Vector2.ZERO

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

func _ready():
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

	
func _physics_process(delta):
	basic_movement_handler.tick(delta)
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

func land():
	animation_handler.set_state("jump_end")

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
