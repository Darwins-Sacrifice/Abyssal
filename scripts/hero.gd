extends Entity

# Load Actions
var nothing = load_action("nothing",1)
var hurt_self = load_action("hurt_self",2)
var raise_max_hp = load_action("raise_max_hp",3)
var flash = load_action("flash",2)
var heal_self = load_action("heal_self",3)

var equippedActions: Array = [nothing,hurt_self,raise_max_hp,flash,heal_self] 
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
		execute_action(activeSlot)

func execute_action(slot: int):
	equippedActions[slot].cast(self, null, direction.normalized())

func set_max_hp(amt:int):
	maxHP = amt
	get_parent().hud.adjust_max_hp(maxHP)

	
