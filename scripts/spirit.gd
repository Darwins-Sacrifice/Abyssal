extends Entity

var click_pos = Vector2()

func _physics_process(_delta):
	read_input()
	sprite.play("idle_down")
	move_and_slide()

func read_input():
	velocity = Vector2()
	direction = Vector2()
	moving = false
	if Input.is_action_pressed("right_click"):
		click_pos = get_global_mouse_position()
	if position.distance_to(click_pos) >5:
		moving = true
		direction = (click_pos - position)
		velocity = direction.normalized()*base_speed
