extends CharacterBody2D

@export var speed: float = 125.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -150.0

@export var nearestHook: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var dash_handler: PlayerDash = PlayerDash.new(self)
@onready var basic_movement_handler: PlayerBasicMovement = PlayerBasicMovement.new(self)
@onready var animation_handler: SpriteAnimation = SpriteAnimation.new(animated_sprite)

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
var swingSpeed = 10
var swingForce = 0
var radX


func _ready():
	theta = deg_to_rad(90)
	isGrappling = false
	wasGrappling = false
	radX = 0
	


func _physics_process(delta):
	
	if isGrappling == false:
		
		basic_movement_handler.tick(delta)
		
		if is_on_floor():
			yvel = 0
			xvel = 0
			wasGrappling = false
		
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
			if swingForce <= 1.00:
				swingForce += delta
				angVel += swingForce * delta
		if Input.is_action_pressed("right"):
			if swingForce >= -1.00:
				swingForce -= delta
				angVel -= swingForce * delta
				
		
		
	#print(radius)
	print("theta:" + str(theta))
	print("angVel:" + str(angVel))
	print("angAccel:" + str(angAccel))
	
	
	if Input.is_action_just_pressed("grappling"):
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






 
