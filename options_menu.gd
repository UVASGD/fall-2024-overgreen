extends Control


func _process(delta: float) -> void:
	get_node("PanelContainer/Sprite2D").position += Vector2(.25,0)
	if get_node("PanelContainer/Sprite2D").position == Vector2(357, 75.18):
		get_node("PanelContainer/Sprite2D").position = Vector2(26, 75.18)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")
