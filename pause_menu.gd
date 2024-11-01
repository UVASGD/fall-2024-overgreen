extends Control
var inOptions = false
var inQuit = false
var atStart = true
var firstOption = true
var firstQuit = true

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true;
	#print("paused")
	if atStart:
		get_node("pause").set_modulate(Color(255, 255, 255, 0))
		get_node("pause").visible = true
		#get_node("ColorRect2").set_modulate(Color(255, 255, 255, 0))
		get_node("ColorRect2").visible = true
		atStart = false
	$AnimationPlayer.play("blur")
	print("played blur")
		
func openOptions():
	if firstOption:
		get_node("option").set_modulate(Color(255, 255, 255, 0))
		get_node("option").visible = true
		firstOption = false
	$AnimationPlayer.play("options")
	inOptions = true
	get_node("pause/pauseContainer/Resume").disabled = true
	get_node("pause/pauseContainer/Options").disabled = true
	get_node("pause/pauseContainer/Exit").disabled = true
	
	get_node("quit/quitContainer/Back2").disabled = true
	get_node("quit/quitContainer/Quit").disabled = true
	get_node("quit/quitContainer/To Main").disabled = true
	
	get_node("option/optionContainer/Back").disabled = false
	get_node("option/optionContainer/Fullscreen").disabled = false
		
func closeOptions():
	$AnimationPlayer.play_backwards("options")
	inOptions = false
	get_node("pause/pauseContainer/Resume").disabled = false
	get_node("pause/pauseContainer/Options").disabled = false
	get_node("pause/pauseContainer/Exit").disabled = false
	
	get_node("quit/quitContainer/Back2").disabled = true
	get_node("quit/quitContainer/Quit").disabled = true
	get_node("quit/quitContainer/To Main").disabled = true
	
	get_node("option/optionContainer/Back").disabled = true
	get_node("option/optionContainer/Fullscreen").disabled = true
	
func openQuit():
	if firstQuit:
		get_node("quit").set_modulate(Color(255, 255, 255, 0))
		get_node("quit").visible = true
		firstQuit = false
		print("first quitted")
	$AnimationPlayer.play("quit")
	inQuit = true
	get_node("pause/pauseContainer/Resume").disabled = true
	get_node("pause/pauseContainer/Options").disabled = true
	get_node("pause/pauseContainer/Exit").disabled = true
	
	get_node("quit/quitContainer/Back2").disabled = false
	get_node("quit/quitContainer/Quit").disabled = false
	get_node("quit/quitContainer/To Main").disabled = false
	
	get_node("option/optionContainer/Back").disabled = true
	get_node("option/optionContainer/Fullscreen").disabled = true
	
func closeQuit():
	$AnimationPlayer.play_backwards("quit")
	inQuit = false
	get_node("pause/pauseContainer/Resume").disabled = false
	get_node("pause/pauseContainer/Options").disabled = false
	get_node("pause/pauseContainer/Exit").disabled = false
	
	get_node("quit/quitContainer/Back2").disabled = true
	get_node("quit/quitContainer/Quit").disabled = true
	get_node("quit/quitContainer/To Main").disabled = true
	
	get_node("option/optionContainer/Back").disabled = true
	get_node("option/optionContainer/Fullscreen").disabled = true
	
func _process(delta: float) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		get_node("option/optionContainer/Fullscreen").set_text("Go Fullscreen")
	else:
		get_node("option/optionContainer/Fullscreen").set_text("Go Windowed")
	
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused:
			pause()
		elif get_tree().paused:
			if inOptions:
				closeOptions()
			elif inQuit:
				closeQuit()
			else:
				resume()
				inOptions = false
				inQuit = false
				#$AnimationPlayer.play_backwards("options")

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		get_node("option/optionContainer/Fullscreen").set_text("Go Windowed")

func _on_resume_pressed() -> void:
	resume()
	
func _on_options_pressed() -> void:
	openOptions()
	
func _on_back_pressed() -> void:
	closeOptions()

func _on_back_2_pressed() -> void:
	closeQuit()
	
func _on_exit_pressed() -> void:
	openQuit()

func _on_fullscreen_pressed() -> void:
	#display/window/size/mode = 1
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		get_node("option/optionContainer/Fullscreen").set_text("Go Windowed")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_node("option/optionContainer/Fullscreen").set_text("Go Fullscreen")

func _on_to_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://start_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
