extends Node2D

func read_input():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _process(_delta):
	read_input()
