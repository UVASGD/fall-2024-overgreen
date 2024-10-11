extends Control



func _on_start_new_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")



func _on_continue_pressed() -> void:
	pass # Replace with function body.



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()
