extends CharacterBody2D

const speed = 125.0
var dir: Vector2 = Vector2.ZERO
var trigger = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var animation_handler: SpriteAnimation

func _ready():
	$Timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	$Timer.wait_time = 1.5
	$Timer.start()
	animation_handler = SpriteAnimation.new($AnimatedSprite2D)
	animated_sprite.play("default")
	animation_handler.set_state("default")

func _process(delta):
	position += dir * speed * delta
	#print("Direction:", dir, " Speed:", speed)

func _on_timer_timeout():
	$Timer.wait_time = 1.5
	if trigger:
		dir = Vector2.LEFT
		trigger = false
	else:
		dir = Vector2.RIGHT
		trigger = true
