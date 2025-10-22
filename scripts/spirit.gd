extends Entity

func spirit_init(): #Special Initialization for Spirit
	STATUS["teleporting"] = false
	STATUS["targetPos"] = position
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
				main.hud.update_spirit_cooldown(i + 1, STATUS["action_cooldowns"][i])

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

	# Scroll wheel to cycle through action slots
	if Input.is_action_just_pressed("scroll_up"):
		set_active_slot(STATUS["activeSlot"] - 1)
	if Input.is_action_just_pressed("scroll_down"):
		set_active_slot(STATUS["activeSlot"] + 1)

	# Cast action with left click
	if Input.is_action_just_pressed("cast_spirit"):
		execute_action(STATUS["activeSlot"])

	# Quick cast actions
	if Input.is_action_just_pressed("spirit_quick_cast_1"):
		set_active_slot(1)
		execute_action(1)
	if Input.is_action_just_pressed("spirit_quick_cast_2"):
		set_active_slot(2)
		execute_action(2)
	if Input.is_action_just_pressed("spirit_quick_cast_3"):
		set_active_slot(3)
		execute_action(3)
	if Input.is_action_just_pressed("spirit_quick_cast_4"):
		set_active_slot(4)
		execute_action(4)
	if Input.is_action_just_pressed("spirit_quick_cast_5"):
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
		# Get target nearest to cursor within range
		var cursor_pos = get_global_mouse_position()
		var nearest_enemy = null
		var nearest_distance = INF

		for entity in world.get_children():
			if entity is Entity and entity.INFO["type"] == "Enemy":
				var dist_to_cursor = entity.global_position.distance_to(cursor_pos)
				if dist_to_cursor <= INFO["range"] and dist_to_cursor < nearest_distance:
					nearest_enemy = entity
					nearest_distance = dist_to_cursor

		target = nearest_enemy

	# Cast the action
	executableAct.cast(self, target, STATUS["facing_direction"])

	# Start cooldown
	STATUS["action_cooldowns"][i-1] = ACTION_DATA[executableAct.key]["cooldown"]
	main.hud.update_spirit_cooldown(i, STATUS["action_cooldowns"][i-1])

func set_active_slot(i: int):
	STATUS["activeSlot"] = i
	if STATUS["activeSlot"] > STATUS["equippedActions"].size(): STATUS["activeSlot"] = 1
	if STATUS["activeSlot"] < 1: STATUS["activeSlot"] = STATUS["equippedActions"].size()
	main.hud.select_spirit_slot(STATUS["activeSlot"])

func equip_action(actionKey: String, i : int):
	super.equip_action(actionKey, i)
	main.hud.get_spirit_slot_sprite(i).region_rect = main.ACTION_DATA[actionKey]["region"]
