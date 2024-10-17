extends CharacterBody2D

@export var speed: float = 125.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var dash_handler: PlayerDash = PlayerDash.new(self)
@onready var basic_movement_handler: PlayerBasicMovement = PlayerBasicMovement.new(self)
@onready var animation_handler: SpriteAnimation = SpriteAnimation.new(animated_sprite)

var direction: Vector2 = Vector2.ZERO
var theta
var isGrappling
var radius = 10.0

func _ready():
	theta = -3
	isGrappling = false

func _physics_process(delta):
	var t = 0
	if isGrappling == false:
		basic_movement_handler.tick(delta)
	else:
		position.x = radius * cos(theta)
		position.y = radius * sin(theta)
		
		
		if Input.is_action_pressed("left"):
			theta = 0
		if Input.is_action_pressed("right"):
			theta = 180
		if Input.is_action_pressed("up"):
			theta = 90
		if Input.is_action_pressed("down"):
			theta = 270
		
	
	if Input.is_action_just_pressed("grappling"):
		isGrappling = !isGrappling
		
	animation_handler.tick(direction)

func land():
	animation_handler.set_state("jump_end")

 
