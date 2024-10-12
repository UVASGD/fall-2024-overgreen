extends Control

func _on_back_pressed() -> void:
	$AnimationPlayer2.play_backwards("options")
