extends Node

# Preload music
var Our_Mountain = preload("res://assets/audio/Our Mountain.mp3")

# Preload sprites
var hero_sprite = preload("res://assets/sprite/hero.tres")
var spirit_sprite = preload("res://assets/sprite/spirit.tres")

# Preload scenes
var hero_scene = preload("res://scenes/hero.tscn")
var spirit_scene = preload("res://scenes/spirit.tscn")
var hud_scene = preload("res://scenes/hud.tscn")
var pause_menu_scene = load("res://scenes/pause_menu.tscn") 

# Instances
var hero = hero_scene.instantiate()
var spirit = spirit_scene.instantiate()
var hud = hud_scene.instantiate()
var pauseMenu = pause_menu_scene.instantiate()

# Variables
@onready var DATABASE = $DATABASE
@onready var ACTION_DATA = $DATABASE.ACTION_DATA
@onready var themeMusic = $ThemeMusic
@onready var camera = $Camera

var clock : float = 0
var paused : bool = false

func _ready():
	camera.init()

	themeMusic.stream = Our_Mountain
	themeMusic.play()

	add_child(hero)
	hero.init("Hero", "Kaladin",Vector2())
	hero.hero_init()
	
	add_child(spirit)
	spirit.init("Spirit", "Syl", Vector2())
	spirit.spirit_init()
	
	add_child(hud)
	hud.init()

	var knownList = ["flash","nothing","heal_self","hurt_self","raise_max_hp"]
	hero.learn_action_set(knownList)
	var equippedList = ["flash","nothing","heal_self","hurt_self","raise_max_hp"]
	hero.equip_action_set(equippedList)

func _process(delta):
	if !paused:
		read_input()
		clock += delta

func read_input():
	if Input.is_action_just_pressed("options"):
		pauseMenu.pause(self)

func end_game():
	print_debug("GAME OVER - YOU DIED")
	get_tree().quit()
