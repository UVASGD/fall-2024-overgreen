extends Control

func resume():
	get_tree().paused = false
	print("resumed")
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true;
	print("paused")
	$AnimationPlayer.play("blur")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_exit_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")
	
