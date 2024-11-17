extends Node2D

@onready var label = $Label
@onready var timer = $Timer
@onready var total_time_seconds : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()
	print("Started")

func _on_timer_timeout():
	total_time_seconds += 1
	var minutes = int (total_time_seconds / 60)
	var seconds = total_time_seconds % 60
	
	$Label.text = '%02d:%02d' % [minutes,seconds]
	
	if total_time_seconds == 360:
		get_tree().change_scene_to_file("res://pause-start/game-over-times-up.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
