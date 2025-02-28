extends Entity

func spirit_init(): #Special Initialization for Spirit
	STATUS["teleporting"] = false
	STATUS["targetPos"] = position

func _physics_process(_delta):
	if !main.paused:
		read_input()
		move()

func read_input():
	if !STATUS["teleporting"]:
		if Input.is_action_just_pressed("right_click"):
			STATUS["targetPos"] = get_global_mouse_position()
	else:
		STATUS["targetPos"] = main.hero.global_position
		if position.distance_to(STATUS["targetPos"]) <100:
			set_collision_mask_value(6,true)
			STATUS["teleporting"] = false
			STATUS["running"] = false
	
	if position.distance_to(STATUS["targetPos"]) <10:
		STATUS["targetPos"] = position
	STATUS["direction"] = STATUS["targetPos"] - position
	
	if Input.is_action_just_pressed("teleport_to_hero"):
		set_collision_mask_value(6,false)
		STATUS["teleporting"] = true
		STATUS["running"] = true
