extends Node2D

@export var startPos: Vector2

func _ready():
	position = startPos
	
func _process(delta: float) -> void:
	queue_redraw()

#func _draw():
	#draw_line(Vector2(500, 500), position, Color.RED, 10.0)
