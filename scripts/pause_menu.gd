extends Control

var main : Node

func _process(_delta):
	read_input()

func read_input():
	if Input.is_action_just_pressed("options"):
		resume()

func pause(game : Node):
	Engine.time_scale = 0
	main = game
	main.add_child(self)
	position = main.camera.get_screen_center_position()-(size/2)
	main.paused = true
	main.hud.hide()

func resume():
	Engine.time_scale = 1
	main.paused = false
	main.hud.show()
	main.remove_child(self)

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	var options_scene = load("res://scenes/options_menu.tscn") 
	var optionMenu = options_scene.instantiate()
	main.add_child(optionMenu)
	optionMenu.position = main.camera.get_screen_center_position()-(optionMenu.size/2)

func _on_save_game_pressed():
	pass # Replace with function body.

func _on_resume_pressed():
	resume()

func _on_main_menu_pressed():
	var main_menu_scene = load("res://scenes/main_menu.tscn") 
	get_tree().change_scene_to_packed(main_menu_scene)
	resume()
	
