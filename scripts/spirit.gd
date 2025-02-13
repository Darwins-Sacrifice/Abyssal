extends Entity

var click_pos : Vector2 = spawn_point

func _physics_process(_delta):
	read_input()
	move()

func read_input():
	moving = false
	if Input.is_action_just_pressed("right_click"):
		click_pos = get_global_mouse_position()
	direction = (click_pos - position)
	if position.distance_to(click_pos) >10:
		moving = true
	if moving:
		velocity = direction.normalized()*base_speed
	else: 
		velocity = Vector2()
	direction = round(direction.normalized())
	if !moving && direction.x != 0: direction.y = 0
