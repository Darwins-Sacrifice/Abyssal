extends CharacterBody2D

var direction : Vector2
var sprite : AnimatedSprite2D
var speed : float
var run_mod : float = 2
var animatespeed : float = 1

func _ready():
	sprite = $hero_sprite
	
func read_input():
	velocity = Vector2()
	direction = Vector2()
	speed = 200
	sprite.speed_scale = 1
	
	if Input.is_action_pressed("hero_up"):
		velocity.y = -1
		direction = Vector2(0,-1)
	if Input.is_action_pressed("hero_down"):
		velocity.y = 1
		direction = Vector2(0,1)
	if Input.is_action_pressed("hero_left"):
		velocity.x = -1
		direction = Vector2(-1,0)
	if Input.is_action_pressed("hero_right"):
		velocity.x = 1
		direction = Vector2(1,0)
	if Input.is_action_pressed("run"):
		speed = speed * run_mod
		sprite.speed_scale = sprite.speed_scale*run_mod
	
	velocity = velocity.normalized()*speed
	match direction:
		Vector2(0,0):
			sprite.stop()
		Vector2(0,-1):
			sprite.play("walk_up")
		Vector2(0,1):
			sprite.play("walk_down")
		Vector2(-1,0):
			sprite.play("walk_left")
		Vector2(1,0):
			sprite.play("walk_right")
		Vector2(-1,-1):
			sprite.play("walk_up")
		Vector2(-1,1):
			sprite.play("walk_right")
		Vector2(1,-1):
			sprite.play("walk_left")
		Vector2(1,1):
			sprite.play("walk_down")
	
	move_and_slide()
	
func _physics_process(_delta):
	read_input()
