extends Entity

var click_pos = Vector2()

func spirit_init(): #Special Initialization for Spirit Only
	click_pos = position
	STATUS["teleporting"] = false

func _physics_process(_delta):
	if !main.paused:
		read_input()	
		move()

func read_input():
	#Get direction and move status
	if Input.is_action_just_pressed("teleport_to_hero"):
		set_collision_mask_value(6,false)
		STATUS["teleporting"] = true
		STATUS["running"] = true
	if STATUS["teleporting"]:
		click_pos = main.hero.global_position
		if position.distance_to(click_pos) <100:
			set_collision_mask_value(6,true)
			STATUS["teleporting"] = false
			STATUS["running"] = false
	else: 
		if Input.is_action_just_pressed("right_click"):
			click_pos = get_global_mouse_position()
			
	STATUS["direction"] = click_pos - position
	if position.distance_to(click_pos) >10: STATUS["moving"] = true
	else: STATUS["moving"] = false

	#Set velocity and generalize direction
	if STATUS["moving"]: 
		velocity = STATUS["direction"].normalized()*STATS["baseSpeed"]
	else: velocity = Vector2()
	STATUS["direction"] = round(STATUS["direction"].normalized())
	if !STATUS["moving"] && STATUS["direction"].x != 0: STATUS["direction"].y = 0