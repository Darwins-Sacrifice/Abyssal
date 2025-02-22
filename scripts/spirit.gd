extends Entity

var click_pos : Vector2 = spawnPoint
var teleporting = false

func _physics_process(_delta):
	if !get_tree().root.get_node("main").paused:
		read_input()
		move()

func read_input():
	moving = false
	if Input.is_action_just_pressed("teleport_to_hero"):
		click_pos = main.hero.global_position
		set_collision_mask_value(6,false)
		teleporting = true
		running = true
	if !teleporting:
		if Input.is_action_just_pressed("right_click"):
			click_pos = get_global_mouse_position()
	else: 
		click_pos = main.hero.global_position
		if position.distance_to(click_pos) <100:
			teleporting = false
			running = false
			set_collision_mask_value(6,true)
	direction = (click_pos - position)
	if position.distance_to(click_pos) >10:
		moving = true
	if moving:
		velocity = direction.normalized()*baseSpeed
	else: 
		velocity = Vector2()
	direction = round(direction.normalized())
	if !moving && direction.x != 0: direction.y = 0
