extends Node2D

# Preload music
var theme_music = preload("res://assets/audio/Our Mountain.mp3")

# Preload sprites
var hero_sprite = preload("res://assets/sprite/hero.tres")
var spirit_sprite = preload("res://assets/sprite/spirit.tres")

# Preload scenes
var hero_scene = preload("res://scenes/hero.tscn")
var spirit_scene = preload("res://scenes/spirit.tscn")

# Instances
var hero = hero_scene.instantiate()
var spirit = spirit_scene.instantiate()

# Variables
var camera = Camera2D
var cam_target = hero

func _ready():
	add_child(hero)
	hero.init("player",Vector2(0,0),hero_sprite)
	add_child(spirit)
	hero.init("player",Vector2(0,0),spirit_sprite)
	camera = Camera2D.new()
	add_child(camera)

func _process(_delta):
	read_input()
	camera.position = cam_target.position

func read_input():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("camera_swap"):
		if cam_target == hero: cam_target = spirit
		else: cam_target = hero
