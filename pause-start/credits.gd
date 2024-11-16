extends Control

func _ready() -> void:
	get_node("PanelContainer2/Sprite2D").position = get_node("/root/BackgroundPos").pos - Vector2(.2,0)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_node("/root/BackgroundPos").pos = get_node("PanelContainer2/Sprite2D").position
		get_tree().change_scene_to_file("res://pause-start/start_menu.tscn")
	
	get_node("PanelContainer2/Sprite2D").position -= Vector2(.2,0)
	if get_node("PanelContainer2/Sprite2D").position <= Vector2(38, 128.18):
		get_node("PanelContainer2/Sprite2D").position = Vector2(590, 128.18)

func _on_back_pressed() -> void:
	get_node("/root/BackgroundPos").pos = get_node("PanelContainer2/Sprite2D").position
	get_tree().change_scene_to_file("res://pause-start/start_menu.tscn")
