extends Entity

# Load Actions
var nothing = load_action("nothing")
var hurt_self = load_action("hurt_self")
var raise_max_hp = load_action("raise_max_hp")
var flash = load_action("flash")
var heal_self = load_action("heal_self")

var equippedActions: Array = [nothing,nothing,nothing,nothing,nothing] 
var activeSlot: int = 1

func _physics_process(_delta):
	read_input()
	move()

func read_input():
	moving = false
	running = false
	if Input.is_action_pressed("up") || Input.is_action_pressed("down") || Input.is_action_pressed("left") || Input.is_action_pressed("right"):
		direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
		moving = true
		if Input.is_action_pressed("run"): running = true
	if moving:
		if running: velocity = direction.normalized()*runSpeed
		else: velocity = direction.normalized()*baseSpeed
	else: velocity = Vector2()
	if Input.is_action_just_pressed("cycle_action_left"):
		if activeSlot > 1: activeSlot -= 1
		else: activeSlot = equippedActions.size()
		main.hud.select_action(activeSlot)
	if Input.is_action_just_pressed("cycle_action_right"):
		if activeSlot < equippedActions.size(): activeSlot += 1
		else: activeSlot = 1
		main.hud.select_action(activeSlot)
	if Input.is_action_just_pressed("cast"):
		execute_action(activeSlot)
	if Input.is_action_just_pressed("quick_cast_1"):
		activeSlot = 1
		main.hud.select_action(activeSlot)
		execute_action(activeSlot)
	if Input.is_action_just_pressed("quick_cast_2"):
		activeSlot = 2
		main.hud.select_action(activeSlot)
		execute_action(activeSlot)
	if Input.is_action_just_pressed("quick_cast_3"):
		activeSlot = 3
		main.hud.select_action(activeSlot)
		execute_action(activeSlot)
	if Input.is_action_just_pressed("quick_cast_4"):
		activeSlot = 4
		main.hud.select_action(activeSlot)
		execute_action(activeSlot)
	if Input.is_action_just_pressed("quick_cast_5"):
		activeSlot = 5
		main.hud.select_action(activeSlot)
		execute_action(activeSlot)

func execute_action(slot: int):
	equippedActions[slot-1].cast(self, null, direction.normalized())

func set_max_hp(amt:int):
	maxHP = amt
	get_parent().hud.adjust_max_hp(maxHP)

func equip_action(n : String, slot : int):
	equippedActions[slot-1] = load_action(n)
	main.hud.actionBar.get_children()[slot-1].get_node("action_slot").get_node("actionSprite").region_rect = main.DATA[n]["region"]
	
