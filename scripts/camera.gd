extends Camera2D

var target : CharacterBody2D
var hero : CharacterBody2D
var spirit : CharacterBody2D

func _ready() -> void:
	hero = get_parent().get_node("Hero")
	spirit = get_parent().get_node("Spirit")
	target = hero

func read_input():
	if Input.is_action_just_pressed("camera_swap"):
		if target == hero:
			target = spirit
		else: if target == spirit:
			target = hero

func _process(_delta):
	read_input()
	position = target.position
