extends CharacterBody2D

const speed = 30;
var dir: Vector2;

func _on_timer_timeout():
	$Timer.wait_time = 3;
	if Vector2.UP:
		Vector2.DOWN;
	else:
		Vector2.UP;
