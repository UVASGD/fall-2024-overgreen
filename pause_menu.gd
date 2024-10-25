extends Control
var inOptions = false
var atStart = true
var firstOption = true
#onready var nodeA = get_node("pause")
var buttons = [get_node("pause/pauseContainer/Resume"),
get_node("pause/pauseContainer/Options"),
get_node("pause/pauseContainer/Quit"),
get_node("pause/pauseContainer/Exit to Main Menu"),
get_node("option/optionContainer/Back")]

func resume():
	get_tree().paused = false
	#print("resumed")
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true;
	#print("paused")
	$AnimationPlayer.play("blur")
	if atStart:
		get_node("pause").set_modulate(Color(255, 255, 255, 0))
		get_node("pause").visible = true
		atStart = false
		
func openOptions():
	if firstOption:
		get_node("option").set_modulate(Color(255, 255, 255, 0))
		get_node("option").visible = true
		firstOption = false
	$AnimationPlayer.play("options")
	inOptions = true
	get_node("pause/pauseContainer/Resume").disabled = true
	get_node("pause/pauseContainer/Options").disabled = true
	get_node("pause/pauseContainer/Quit").disabled = true
	get_node("pause/pauseContainer/Exit to Main Menu").disabled = true
	get_node("option/optionContainer/Back").disabled = false
	get_node("option/optionContainer/Fullscreen").disabled = false
		
func closeOptions():
	$AnimationPlayer.play_backwards("options")
	get_node("pause/pauseContainer/Resume").disabled = false
	get_node("pause/pauseContainer/Options").disabled = false
	get_node("pause/pauseContainer/Quit").disabled = false
	get_node("pause/pauseContainer/Exit to Main Menu").disabled = false
	get_node("option/optionContainer/Back").disabled = true
	get_node("option/optionContainer/Fullscreen").disabled = true
	inOptions = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		if !get_tree().paused:
			pause()
		elif get_tree().paused:
			if !inOptions:
				resume()
			else:
				closeOptions()
				#$AnimationPlayer.play_backwards("options")
				inOptions = false;

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		get_node("option/optionContainer/Fullscreen").set_text("Go Windowed")

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_exit_to_main_menu_pressed() -> void:
	print("exited to main")
	#get_tree().paused = false
	await get_tree().create_timer(0.001).timeout
	get_tree().change_scene_to_file("res://start_menu.tscn")
	
func _on_options_pressed() -> void:
	openOptions()
	"""if firstOption:
		get_node("option").set_modulate(Color(255, 255, 255, 0))
		get_node("option").visible = true
		firstOption = false
	$AnimationPlayer.play("options")
	inOptions = true
	get_node("pause/pauseContainer/Resume").disabled = true
	get_node("pause/pauseContainer/Options").disabled = true
	get_node("pause/pauseContainer/Quit").disabled = true
	get_node("pause/pauseContainer/Exit to Main Menu").disabled = true
	get_node("option/optionContainer/Back").disabled = false"""
	
func _on_back_pressed() -> void:
	closeOptions()
	"""$AnimationPlayer.play_backwards("options")
	get_node("pause/pauseContainer/Resume").disabled = false
	get_node("pause/pauseContainer/Options").disabled = false
	get_node("pause/pauseContainer/Quit").disabled = false
	get_node("pause/pauseContainer/Exit to Main Menu").disabled = false
	get_node("option/optionContainer/Back").disabled = true
	inOptions = false;"""


func _on_fullscreen_pressed() -> void:
	#display/window/size/mode = 1
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		get_node("option/optionContainer/Fullscreen").set_text("Go Windowed")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_node("option/optionContainer/Fullscreen").set_text("Go Fullscreen")
