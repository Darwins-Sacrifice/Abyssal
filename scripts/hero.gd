extends Entity

func _physics_process(_delta):
	read_input()
	move_and_slide()

func read_input():
	velocity = Vector2()
	moving = false
	if Input.is_action_pressed("hero_up"):
		direction.y = -1
		moving = true
	if Input.is_action_pressed("hero_down"):
		direction.y = 1
		moving = true
	if Input.is_action_pressed("hero_left"):
		direction.x = -1
		moving = true
	if Input.is_action_pressed("hero_right"):
		direction.x = 1
		moving = true
	if Input.is_action_pressed("run"):
		set_speed(run_speed)
	else:
		set_speed(base_speed)
	if moving == true:
		velocity = direction.normalized()*speed
	else:
		match sprite.animation:
			"up_idle": direction = Vector2(0,-1)
			"down_idle": direction = Vector2(0,1)
			"left_idle": direction = Vector2(-1,0)
			"right_idle": direction = Vector2(1,0)

func action(slot):
	match slot:
		1: 
				var bomb = Sprite2D.new()
				add_child(bomb)
				bomb.texture = load("res://assets/image/bomb.png")
				bomb.position = Vector2(0,0)
				bomb.visible = true
				bomb.z_index = 3
