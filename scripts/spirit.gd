extends CharacterBody2D

var direction : Vector2
var sprite : AnimatedSprite2D
var speed : float
var run_mod : float = 2
var animatespeed : float = 1
var click_pos = Vector2()
var target_pos = Vector2()

func _ready():
	sprite = $spirit_sprite
	sprite.play("idle")
	
func read_input():
	velocity = Vector2()
	direction = Vector2()
	speed = 300
	sprite.speed_scale = 1
	
	if Input.is_action_just_pressed("right_click"):
		click_pos = get_global_mouse_position()
	if position.distance_to(click_pos) >3:
		target_pos = (click_pos - position).normalized()
		velocity = target_pos * speed
	move_and_slide()
	
func _physics_process(_delta):
	read_input()
