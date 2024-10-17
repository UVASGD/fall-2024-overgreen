extends Control

func _on_back_pressed() -> void:
	$AnimationPlayer.play_backwards("options")
