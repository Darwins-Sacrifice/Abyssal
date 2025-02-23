extends Camera2D

var main : Node
var target : Entity

func init():
	main = get_parent()
	target = main.hero

func _process(_delta):
	if !main.paused:
		read_input()
		position = target.position

func read_input():
		if Input.is_action_just_pressed("camera_swap"):
			if target == main.hero: target = main.spirit
			else: target = main.hero
