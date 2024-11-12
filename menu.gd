extends Control
@export var pos = Vector2(357, 75.18)

func _process(delta: float) -> void:
	get_node("PanelContainer/Sprite2D").position -= Vector2(.25,0)
	pos = get_node("PanelContainer/Sprite2D").position
	if get_node("PanelContainer/Sprite2D").position == Vector2(26, 75.18):
		get_node("PanelContainer/Sprite2D").position = Vector2(357, 75.18)

func _on_start_new_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")



func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
