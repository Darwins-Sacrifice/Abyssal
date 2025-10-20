extends Control

func _on_quit_pressed():
	get_tree().quit()

func _on_new_game_pressed():
	var game_scene = load("res://scenes/main.tscn") 
	get_tree().change_scene_to_packed(game_scene)

func _on_options_pressed():
	var options_scene = load("res://scenes/options_menu.tscn") 
	var optionMenu = options_scene.instantiate()
	add_child(optionMenu)

func _on_load_game_pressed():
	pass # Replace with function body.
