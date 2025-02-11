extends Entity

func _physics_process(_delta):
	read_input()
	match direction:
		Vector2(0,0):
			sprite.stop()
		Vector2(0,-1):
			if moving: sprite.play("up")
			else:sprite.play("up_idle")
		Vector2(0,1):
			if moving: sprite.play("down")
			else:sprite.play("down_idle")
		Vector2(-1,0),Vector2(-1,-1),Vector2(-1,1):
			if moving: sprite.play("left")
			else:sprite.play("left_idle")
		Vector2(1,0), Vector2(1,1),Vector2(1,-1):
			if moving: sprite.play("right")
			else:sprite.play("right_idle")
	move_and_slide()

func read_input():
	velocity = Vector2()
	direction = Vector2()
	moving = false
	if Input.is_action_pressed("hero_up"):
		if Input.is_action_pressed("hero_down"): direction.y = 0
		else: 
			direction.y = -1
			moving = true
	if Input.is_action_pressed("hero_down"):
		if Input.is_action_pressed("hero_up"): direction.y = 0
		else: 
			direction.y = 1
			moving = true
	if Input.is_action_pressed("hero_left"):
		if Input.is_action_pressed("hero_right"): direction.x = 0
		else: 
			direction.x = -1
			moving = true
	if Input.is_action_pressed("hero_right"):
		if Input.is_action_pressed("hero_left"): direction.x = 0
		else: 
			direction.x = 1
			moving = true
	if Input.is_action_pressed("run"):
		set_speed(run_speed)
	else:
		set_speed(base_speed)
	if moving == true:
		velocity = direction.normalized()*speed
