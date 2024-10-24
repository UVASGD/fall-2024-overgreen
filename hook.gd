extends Node2D

func _ready():
	position = Vector2(0, 0)

func _draw():
	draw_line(Vector2(10, 0), position, Color.BLACK, 10.0)
	
func _process(delta: float) -> void:
	queue_redraw()
