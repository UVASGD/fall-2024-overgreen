extends Control

func _ready() -> void:
	get_node("PanelContainer/Sprite2D").position = get_node("/root/BackgroundPos").pos - Vector2(.2,0)

func _process(delta: float) -> void:
	get_node("PanelContainer/Sprite2D").position -= Vector2(.2,0)
	if get_node("PanelContainer/Sprite2D").position <= Vector2(38, 128.18):
		get_node("PanelContainer/Sprite2D").position = Vector2(590, 128.18)

func _on_start_new_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")



func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")



func _on_options_pressed() -> void:
	get_node("/root/BackgroundPos").pos = get_node("PanelContainer/Sprite2D").position
	get_tree().change_scene_to_file("res://pause-start/options_menu.tscn")



func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_node("/root/BackgroundPos").pos = get_node("PanelContainer/Sprite2D").position
	get_tree().change_scene_to_file("res://pause-start/credits.tscn")
