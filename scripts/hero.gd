extends Entity

# Load Actions
var nothing = load_action("nothing")
var flash = load_action("flash")

var equippedActions: Array = [nothing,flash,nothing,nothing,nothing]
var activeSlot: int = 0

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
		if activeSlot > 0: activeSlot -= 1
		else: activeSlot = equippedActions.size()-1
	if Input.is_action_just_pressed("cycle_action_right"):
		if activeSlot < equippedActions.size()-1: activeSlot += 1
		else: activeSlot = 0
	if Input.is_action_just_pressed("cast"):
		set_max_hp(maxHP+1)
		execute_action(activeSlot)

func execute_action(slot: int):
	equippedActions[slot].cast(self, null, direction.normalized())

func set_max_hp(amt:int):
	maxHP = amt
	get_parent().get_node("Hud").adjust_max_hp(maxHP)

	