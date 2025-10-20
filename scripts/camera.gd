extends Camera2D

var target : Entity
var world : Node
var main : Node

func init():
	target = get_parent()
	world = target.get_parent()
	main = world.get_parent()
	set_name("Camera")

func _physics_process(_delta):
	if !main.paused:
		read_input()
	global_position = target.global_position

func read_input():
		if Input.is_action_just_pressed("camera_swap"):
			if target == main.hero: reparent(main.spirit)
			else: reparent(main.hero)
			target = get_parent()
