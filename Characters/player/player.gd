extends CharacterBody2D

@export var speed: float = 125.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var dash_handler: PlayerDash = PlayerDash.new(self)
@onready var basic_movement_handler: PlayerBasicMovement = PlayerBasicMovement.new(self)
@onready var animation_handler: SpriteAnimation = SpriteAnimation.new(animated_sprite)

@onready var grapple_scene = preload("res://Characters/hook.tscn")

var direction: Vector2 = Vector2.ZERO
var theta: float
var isGrappling
var radius: float = 100.0
var gravity: float = 20.0
var angAccel = 0
var angVel = 0

func _ready():
	theta = 180.0
	isGrappling = false

func _physics_process(delta):
	if isGrappling == false:
		angAccel = 0
		angVel = 0
		
		basic_movement_handler.tick(delta)
	else:
		
		angAccel = ang_accel()
		angVel += angAccel * delta
		theta += angVel * delta
		
		position = Vector2(radius * cos(theta + (PI/2)), radius * sin(theta + (PI/2)))
		
	
		#print(theta)
		#print(angaccel)
	
	if Input.is_action_just_pressed("grappling"):
		isGrappling = !isGrappling
		
	animation_handler.tick(direction)
	queue_redraw()
	
func land():
	animation_handler.set_state("jump_end")
	
func ang_accel() -> float:
	return -1 * (gravity/radius) * sin(theta)
	
func _draw():
	if isGrappling:
		draw_line(Vector2(0, 0), -position, Color.BLACK, 5.0)



#func move_towards_grapple(delta):
	#var grapple_speed = 5
	#var grapple_point = Vector2(0, 0)
	#var direction = (grapple_point - global_position).normalized()
	#velocity = direction * grapple_speed
	#move_and_slide()
#
#func grapple(L, angleI, delta):
	#theta = 0
	#var vertical = Vector2(0, -L)
	#var player_pos = Vector2(L * cos(theta), L * sin(theta))
	#position = vertical
	#
	#theta = vertical.angle_to(player_pos)



 
