extends Node2D

# Preload music
var Our_Mountain = preload("res://assets/audio/Our Mountain.mp3")

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
var camera : Camera2D
var cam_target : Entity
var music : AudioStreamPlayer2D
var clock : float = 0

func _ready():
	add_child(hero)
	hero.init("hero",Vector2(100,100),hero_sprite)
	add_child(spirit)
	spirit.init("spirit",Vector2(0,0),spirit_sprite)
	camera = Camera2D.new()
	cam_target = hero
	add_child(camera)
	music = AudioStreamPlayer2D.new()
	music.attenuation = 0
	music.max_distance = INF
	music.stream = Our_Mountain
	add_child(music)
	music.play()

func _process(delta):
	read_input()
	if cam_target != null: camera.position = cam_target.position
	clock += delta

func read_input():
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("camera_swap"):
		if cam_target == hero: cam_target = spirit
		else: cam_target = hero

func end_game():
	get_tree().quit()
