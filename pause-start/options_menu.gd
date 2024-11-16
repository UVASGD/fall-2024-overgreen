extends Control

func _ready() -> void:
	get_node("PanelContainer/Sprite2D").position = get_node("/root/BackgroundPos").pos - Vector2(.2,0)

func _process(delta: float) -> void:
	get_node("PanelContainer/Sprite2D").position -= Vector2(.2,0)
	if get_node("PanelContainer/Sprite2D").position <= Vector2(38, 128.18):
		get_node("PanelContainer/Sprite2D").position = Vector2(590, 128.18)
		
	if Input.is_action_just_pressed("esc"):
		get_node("/root/BackgroundPos").pos = get_node("PanelContainer/Sprite2D").position
		get_tree().change_scene_to_file("res://pause-start/start_menu.tscn")
		
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Fulls").set_text("Go Fullscreen")
	else:
		get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Fulls").set_text("Go Windowed")

func _on_back_pressed() -> void:
	get_node("/root/BackgroundPos").pos = get_node("PanelContainer/Sprite2D").position
	get_tree().change_scene_to_file("res://pause-start/start_menu.tscn")

func _on_fulls_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Fulls").set_text("Go Windowed")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_node("PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/Fulls").set_text("Go Fullscreen")
