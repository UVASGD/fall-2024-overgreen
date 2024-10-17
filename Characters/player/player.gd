extends CharacterBody2D

class_name Player

@export var speed: float = 125.0
@export var jump_velocity: float = -150.0
@export var dash_speed: float = 200;
@export var dash_time: float = 0.25;
@export var dash_num_charges: float = 2.0;

var animation_handler: SpriteAnimation
var dash_handler: PlayerDash
var basic_movement_handler: PlayerBasicMovement
var input_buffer_manager: InputBufferManager

func _ready():
	animation_handler = SpriteAnimation.new($AnimatedSprite2D)
	dash_handler = PlayerDash.new()
	dash_handler.name = "PlayerDash"
	dash_handler.set_constants(dash_speed, dash_time, dash_num_charges)
	basic_movement_handler = PlayerBasicMovement.new()
	basic_movement_handler.name = "PlayerBasicMovement"
	input_buffer_manager = InputBufferManager.new()
	input_buffer_manager.name = "InputBufferManager"
	# add to scene tree
	add_child(dash_handler)
	add_child(basic_movement_handler)
	add_child(input_buffer_manager)


var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	basic_movement_handler.tick(delta)
	dash_handler.tick()
	input_buffer_manager.tick(delta)

func _process(_delta):
	animation_handler.tick(direction)

# func land():
# 	animation_handler.set_state("jump_end")
