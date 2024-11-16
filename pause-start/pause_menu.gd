extends Control
var inOptions = false
var inQuit = false
var atStart = true
var firstOption = true
var firstQuit = true
var inControl = false
var firstControl = true

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true;
	if atStart:
		get_node("pause").set_modulate(Color(255, 255, 255, 0))
		get_node("pause").visible = true
		#get_node("ColorRect2").set_modulate(Color(255, 255, 255, 0))
		get_node("ColorRect2").visible = true
		atStart = false
	$AnimationPlayer.play("blur")
		
func openOptions(fromControl):
	if firstOption:
		get_node("option").set_modulate(Color(255, 255, 255, 0))
		get_node("option").visible = true
		firstOption = false
		
	if !fromControl:
		$AnimationPlayer.play("options")
	inOptions = true
	get_node("pause/MarginContainer/pauseContainer/Resume").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Options").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Exit").disabled = true
	
	get_node("quit/MarginContainer/quitContainer/Back2").disabled = true
	get_node("quit/MarginContainer/quitContainer/Quit").disabled = true
	get_node("quit/MarginContainer/quitContainer/To Main").disabled = true
	
	get_node("option/MarginContainer/optionContainer/Controls").disabled = false
	get_node("option/MarginContainer/optionContainer/Fullscreen").disabled = false
	get_node("option/MarginContainer/optionContainer/HBoxContainer/musicSlider").editable = true
	get_node("option/MarginContainer/optionContainer/HBoxContainer2/sfxSlider").editable = true
	get_node("option/MarginContainer/optionContainer/Back").disabled = false
	
	get_node("InputSettings").set_process_mode(PROCESS_MODE_DISABLED)
		
func closeOptions():
	$AnimationPlayer.play_backwards("options")
	inOptions = false
	get_node("pause/MarginContainer/pauseContainer/Resume").disabled = false
	get_node("pause/MarginContainer/pauseContainer/Options").disabled = false
	get_node("pause/MarginContainer/pauseContainer/Exit").disabled = false
	
	get_node("quit/MarginContainer/quitContainer/Back2").disabled = true
	get_node("quit/MarginContainer/quitContainer/Quit").disabled = true
	get_node("quit/MarginContainer/quitContainer/To Main").disabled = true
	
	get_node("option/MarginContainer/optionContainer/Controls").disabled = true
	get_node("option/MarginContainer/optionContainer/Fullscreen").disabled = true
	get_node("option/MarginContainer/optionContainer/HBoxContainer/musicSlider").editable = false
	get_node("option/MarginContainer/optionContainer/HBoxContainer2/sfxSlider").editable = false
	get_node("option/MarginContainer/optionContainer/Back").disabled = true
	
	get_node("InputSettings").set_process_mode(PROCESS_MODE_DISABLED)
	
func openQuit():
	if firstQuit:
		get_node("quit").set_modulate(Color(255, 255, 255, 0))
		get_node("quit").visible = true
		firstQuit = false
	
	$AnimationPlayer.play("quit")
		
	inQuit = true
	get_node("pause/MarginContainer/pauseContainer/Resume").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Options").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Exit").disabled = true
	
	get_node("quit/MarginContainer/quitContainer/Back2").disabled = false
	get_node("quit/MarginContainer/quitContainer/Quit").disabled = false
	get_node("quit/MarginContainer/quitContainer/To Main").disabled = false
	
	get_node("option/MarginContainer/optionContainer/Controls").disabled = true
	get_node("option/MarginContainer/optionContainer/Fullscreen").disabled = true
	get_node("option/MarginContainer/optionContainer/HBoxContainer/musicSlider").editable = false
	get_node("option/MarginContainer/optionContainer/HBoxContainer2/sfxSlider").editable = false
	get_node("option/MarginContainer/optionContainer/Back").disabled = true
	
	get_node("InputSettings").set_process_mode(PROCESS_MODE_DISABLED)
	
func closeQuit():
	$AnimationPlayer.play_backwards("quit")
	inQuit = false
	get_node("pause/MarginContainer/pauseContainer/Resume").disabled = false
	get_node("pause/MarginContainer/pauseContainer/Options").disabled = false
	get_node("pause/MarginContainer/pauseContainer/Exit").disabled = false
	
	get_node("quit/MarginContainer/quitContainer/Back2").disabled = true
	get_node("quit/MarginContainer/quitContainer/Quit").disabled = true
	get_node("quit/MarginContainer/quitContainer/To Main").disabled = true
	
	get_node("option/MarginContainer/optionContainer/Controls").disabled = true
	get_node("option/MarginContainer/optionContainer/Fullscreen").disabled = true
	get_node("option/MarginContainer/optionContainer/HBoxContainer/musicSlider").editable = false
	get_node("option/MarginContainer/optionContainer/HBoxContainer2/sfxSlider").editable = false
	get_node("option/MarginContainer/optionContainer/Back").disabled = true
	
	get_node("InputSettings").set_process_mode(PROCESS_MODE_DISABLED)
	
func openControl():
	inOptions = false
	inControl = true
	get_node("InputSettings").top_level = true
	if firstControl:
		get_node("InputSettings/PanelContainer").set_modulate(Color(255, 255, 255, 0))
		get_node("InputSettings/PanelContainer").visible = true
		firstControl = false
		
	$AnimationPlayer.play("controls")
	
	get_node("pause/MarginContainer/pauseContainer/Resume").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Options").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Exit").disabled = true
	
	get_node("quit/MarginContainer/quitContainer/Back2").disabled = true
	get_node("quit/MarginContainer/quitContainer/Quit").disabled = true
	get_node("quit/MarginContainer/quitContainer/To Main").disabled = true
	
	get_node("option/MarginContainer/optionContainer/Controls").disabled = true
	get_node("option/MarginContainer/optionContainer/Fullscreen").disabled = true
	get_node("option/MarginContainer/optionContainer/HBoxContainer/musicSlider").editable = false
	get_node("option/MarginContainer/optionContainer/HBoxContainer2/sfxSlider").editable = false
	get_node("option/MarginContainer/optionContainer/Back").disabled = true
	
	get_node("InputSettings").set_process_mode(PROCESS_MODE_ALWAYS)
		
func closeControl():
	$AnimationPlayer.play_backwards("controls")
	inControl = false
	openOptions(true)
	get_node("InputSettings").top_level = false
	"""get_node("pause/MarginContainer/pauseContainer/Resume").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Options").disabled = true
	get_node("pause/MarginContainer/pauseContainer/Exit").disabled = true
	
	get_node("quit/MarginContainer/quitContainer/Back2").disabled = true
	get_node("quit/MarginContainer/quitContainer/Quit").disabled = true
	get_node("quit/MarginContainer/quitContainer/To Main").disabled = true
	
	get_node("option/MarginContainer/optionContainer/Controls").disabled = false
	get_node("option/MarginContainer/optionContainer/Fullscreen").disabled = false
	get_node("option/MarginContainer/optionContainer/musicSlider").editable = true
	get_node("option/MarginContainer/optionContainer/sfxSlider").editable = true
	get_node("option/MarginContainer/optionContainer/Back").disabled = false
	
	get_node("InputSettings").set_process_mode(PROCESS_MODE_DISABLED)"""
	
func _process(delta: float) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		get_node("option/MarginContainer/optionContainer/Fullscreen").set_text("Go Fullscreen")
	else:
		get_node("option/MarginContainer/optionContainer/Fullscreen").set_text("Go Windowed")
	
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused:
			pause()
		elif get_tree().paused:
			if inOptions:
				closeOptions()
			elif inQuit:
				closeQuit()
			elif inControl:
				closeControl()
			else:
				resume()
				inOptions = false
				inQuit = false
				#$AnimationPlayer.play_backwards("options")

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		get_node("option/MarginContainer/optionContainer/Fullscreen").set_text("Go Windowed")

func _on_resume_pressed() -> void:
	resume()
	
func _on_options_pressed() -> void:
	openOptions(false)
	
func _on_back_pressed() -> void:
	closeOptions()

func _on_back_2_pressed() -> void:
	closeQuit()
	
func _on_exit_pressed() -> void:
	openQuit()
	
func _on_controls_pressed() -> void:
	openControl()

func _on_fullscreen_pressed() -> void:
	#display/window/size/mode = 1
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		get_node("option/MarginContainer/optionContainer/Fullscreen").set_text("Go Windowed")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_node("option/MarginContainer/optionContainer/Fullscreen").set_text("Go Fullscreen")

func _on_to_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://pause-start/start_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_3_pressed() -> void:
	closeControl()
