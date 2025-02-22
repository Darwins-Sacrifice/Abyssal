extends Node

# Preload music
var Our_Mountain = preload("res://assets/audio/Our Mountain.mp3")

# Preload sprites
var hero_sprite = preload("res://assets/sprite/hero.tres")
var spirit_sprite = preload("res://assets/sprite/spirit.tres")

# Preload scenes
var action_database_scene = preload("res://scenes/action_database.tscn")
var hero_scene = preload("res://scenes/hero.tscn")
var spirit_scene = preload("res://scenes/spirit.tscn")
var hud_scene = preload("res://scenes/hud.tscn")
var pause_scene = load("res://scenes/pause_menu.tscn") 

# Instances
var actionDatabase = action_database_scene.instantiate()
var hero = hero_scene.instantiate()
var spirit = spirit_scene.instantiate()
var hud = hud_scene.instantiate()
var pauseMenu = pause_scene.instantiate()
# Variables
var DATA = actionDatabase.DATA
var camera : Camera2D
var cam_target : Entity
var music : AudioStreamPlayer
var clock : float = 0
var paused : bool = false

func _ready():
	actionDatabase.init()
	add_child(hero)
	hero.init("hero",Vector2(100,100),hero_sprite)
	add_child(spirit)
	spirit.init("spirit",Vector2(0,0),spirit_sprite)
	camera = $camera
	cam_target = hero
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = Our_Mountain
	music.play()
	add_child(hud)
	hud.init(hero)
	var heroActions = ["flash","nothing","heal_self","hurt_self","raise_max_hp"]
	for i in heroActions.size():
		hero.equip_action(heroActions[i-1],i)


func _process(delta):
	if !paused:
		read_input()
		if cam_target != null: $camera.position = cam_target.position
		clock += delta

func read_input():
	if Input.is_action_just_pressed("options"):
		pauseMenu.pause(self)
	if Input.is_action_just_pressed("camera_swap"):
		if cam_target == hero: cam_target = spirit
		else: cam_target = hero

func end_game():
	print_debug("GAME OVER - YOU DIED")
	get_tree().quit()
