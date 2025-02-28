extends Entity

func hero_init(): #Special Initialization for Hero
	STATUS["equippedActions"] = [null,null,null,null,null]
	STATUS["activeSlot"] = 1

func _physics_process(_delta):
	if !main.paused:
		read_input()
		move()

func read_input():
	STATUS["direction"] = Input.get_vector("left","right","up","down")
	
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
	var target = null
	if ACTION_DATA[executableAct.key]["targeted"]:
		#Get Target
		pass
	executableAct.cast(self, target, STATUS["direction"].normalized())

func set_max_hp(amt: int):
	STATS["maxHP"] = amt
	main.hud.adjust_max_hp(STATS["maxHP"])

func set_active_slot(i: int):
		STATUS["activeSlot"] = i
		if STATUS["activeSlot"] > STATUS["equippedActions"].size(): STATUS["activeSlot"] = 1
		if STATUS["activeSlot"] < 1: STATUS["activeSlot"] = STATUS["equippedActions"].size()
		main.hud.select_slot(STATUS["activeSlot"])

func equip_action(actionKey: String, i : int):
	var newAction = load_action(actionKey)
	var equipable = false
	for known in INFO["knownActions"]:
		if known.key == newAction.key:
			equipable = true
	if equipable:
		STATUS["equippedActions"][i-1] = newAction
		main.hud.get_slot_sprite(i).region_rect = main.ACTION_DATA[newAction.key]["region"]

func equip_action_set(actionSet: Array):
	for i in actionSet.size():
		equip_action(actionSet[i-1],i)
