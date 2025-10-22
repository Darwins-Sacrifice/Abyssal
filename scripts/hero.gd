extends Entity

func hero_init(): #Special Initialization for Hero
	STATUS["equippedActions"] = [null,null,null,null,null]
	STATUS["activeSlot"] = 1
	STATUS["action_cooldowns"] = [0.0, 0.0, 0.0, 0.0, 0.0]

func _physics_process(delta):
	if !main.paused:
		# Reduce cooldowns
		for i in range(STATUS["action_cooldowns"].size()):
			if STATUS["action_cooldowns"][i] > 0:
				STATUS["action_cooldowns"][i] -= delta
				if STATUS["action_cooldowns"][i] < 0:
					STATUS["action_cooldowns"][i] = 0
				main.hud.update_cooldown(i + 1, STATUS["action_cooldowns"][i])

		read_input()
		move()

func read_input():
	var input_dir = Input.get_vector("left","right","up","down")
	STATUS["direction"] = input_dir

	# Update facing direction only when there's actual input to avoid partial key release issues
	if input_dir.length_squared() > 0.01:
		STATUS["facing_direction"] = input_dir.normalized()

	if Input.is_action_pressed("run"):
		STATUS["running"] = true
	else: STATUS["running"] = false
	
	if Input.is_action_just_pressed("cycle_action_left") || Input.is_action_just_pressed("cycle_action_right"):
		set_active_slot(STATUS["activeSlot"] + Input.get_action_strength("cycle_action_right") - Input.get_action_strength("cycle_action_left"))
	
	if Input.is_action_just_pressed("cast"):
		execute_action(STATUS["activeSlot"])
	if Input.is_action_just_pressed("quick_cast_1"):
		set_active_slot(1)
		execute_action(1)
	if Input.is_action_just_pressed("quick_cast_2"):
		set_active_slot(2)
		execute_action(2)
	if Input.is_action_just_pressed("quick_cast_3"):
		set_active_slot(3)
		execute_action(3)
	if Input.is_action_just_pressed("quick_cast_4"):
		set_active_slot(4)
		execute_action(4)
	if Input.is_action_just_pressed("quick_cast_5"):
		set_active_slot(5)
		execute_action(5)

func execute_action(i: int):
	var executableAct = STATUS["equippedActions"][i-1]
	if executableAct == null:
		return

	# Check if action is on cooldown
	if STATUS["action_cooldowns"][i-1] > 0:
		return

	var target = null
	if ACTION_DATA[executableAct.key]["targeted"]:
		# Get target using raycast in facing direction
		raycast.target_position = STATUS["facing_direction"] * INFO["range"]
		raycast.force_raycast_update()
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is Entity and collider.INFO["type"] == "Enemy":
				target = collider

	# Cast the action
	executableAct.cast(self, target, STATUS["facing_direction"])

	# Start cooldown
	STATUS["action_cooldowns"][i-1] = ACTION_DATA[executableAct.key]["cooldown"]
	main.hud.update_cooldown(i, STATUS["action_cooldowns"][i-1])

func set_max_hp(amt: int):
	STATS["maxHP"] = amt
	main.hud.adjust_max_hp(STATS["maxHP"])

func set_active_slot(i: int):
		STATUS["activeSlot"] = i
		if STATUS["activeSlot"] > STATUS["equippedActions"].size(): STATUS["activeSlot"] = 1
		if STATUS["activeSlot"] < 1: STATUS["activeSlot"] = STATUS["equippedActions"].size()
		main.hud.select_slot(STATUS["activeSlot"])

func equip_action(actionKey: String, i : int):
	super.equip_action(actionKey, i)
	main.hud.get_slot_sprite(i).region_rect = main.ACTION_DATA[actionKey]["region"]
