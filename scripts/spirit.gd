extends Entity

var click_pos = Vector2()
var target_pos = Vector2()

func _physics_process(_delta):
	read_input()
	move_and_slide()

func read_input():
	velocity = Vector2()
	direction = Vector2()
	if Input.is_action_just_pressed("right_click"):
		click_pos = get_global_mouse_position()
	if position.distance_to(click_pos) >3:
		target_pos = (click_pos - position).normalized()
		velocity = target_pos * speed
