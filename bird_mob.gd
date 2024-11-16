extends CharacterBody2D

const speed = 125.0
var dir: Vector2 = Vector2.ZERO
var trigger = true

func _ready():
	$Timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	$Timer.wait_time = 1.5
	$Timer.start()

func _process(delta):
	position += dir * speed * delta
	print("Direction:", dir, " Speed:", speed)

func _on_timer_timeout():
	$Timer.wait_time = 1.5
	if trigger:
		dir = Vector2.UP
		trigger = false
	else:
		dir = Vector2.DOWN
		trigger = true
