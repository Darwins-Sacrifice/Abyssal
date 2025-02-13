extends Entity

# Load Actions
var nothing = load_action("nothing")
var flash = load_action("flash")

var equipped_actions: Array = [nothing,flash,nothing,nothing,nothing]
var active_slot: int = 0

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
		if running: velocity = direction.normalized()*run_speed
		else: velocity = direction.normalized()*base_speed
	else: velocity = Vector2()
	if Input.is_action_just_pressed("cycle_action_left"):
		if active_slot > 0: active_slot -= 1
		else: active_slot = equipped_actions.size()-1
	if Input.is_action_just_pressed("cycle_action_right"):
		if active_slot < equipped_actions.size()-1: active_slot += 1
		else: active_slot = 0
	if Input.is_action_just_pressed("cast"):
		execute_action(active_slot)

func execute_action(slot: int):
	equipped_actions[slot].cast(self, null, direction.normalized())
