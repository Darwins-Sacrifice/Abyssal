extends Entity

func spirit_init(): #Special Initialization for Spirit
	STATUS["teleporting"] = false
	STATUS["targetPos"] = position
	STATUS["equippedActions"] = [null,null,null,null,null]
	STATUS["activeSlot"] = 1

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

	# Scroll wheel to cycle through action slots
	if Input.is_action_just_pressed("scroll_up"):
		set_active_slot(STATUS["activeSlot"] - 1)
	if Input.is_action_just_pressed("scroll_down"):
		set_active_slot(STATUS["activeSlot"] + 1)

	# Cast action with left click
	if Input.is_action_just_pressed("cast_spirit"):
		execute_action(STATUS["activeSlot"])

	# Quick cast actions (mouse buttons 4-8)
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
	var target = null
	if ACTION_DATA[executableAct.key]["targeted"]:
		# Get Target
		pass
	executableAct.cast(self, target, STATUS["direction"].normalized())

func set_active_slot(i: int):
	STATUS["activeSlot"] = i
	if STATUS["activeSlot"] > STATUS["equippedActions"].size(): STATUS["activeSlot"] = 1
	if STATUS["activeSlot"] < 1: STATUS["activeSlot"] = STATUS["equippedActions"].size()
	main.hud.select_spirit_slot(STATUS["activeSlot"])

func equip_action(actionKey: String, i : int):
	var newAction = load_action(actionKey)
	var equipable = false
	for known in INFO["knownActions"]:
		if known.key == newAction.key:
			equipable = true
	if equipable:
		STATUS["equippedActions"][i-1] = newAction
		main.hud.get_spirit_slot_sprite(i).region_rect = main.ACTION_DATA[newAction.key]["region"]

func equip_action_set(actionSet: Array):
	for i in actionSet.size():
		equip_action(actionSet[i-1],i)
