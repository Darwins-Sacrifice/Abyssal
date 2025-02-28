extends CharacterBody2D
class_name Entity

var INFO = {  #Entity Information - type, name, knownActions, spawnPoint
	type = "_",
	name = "_",
	knownActions = [],
	spawnPoint = Vector2()
	}

var STATS = { #Entity Stats - maxHP, baseSpeed, runSpeed, runMod
	maxHP = 1,
	baseSpeed = 0,
	runSpeed = 0,
	runMod = 1
}

var STATUS = { #Entity Status - direction, HP, moving, running, casting
	direction = Vector2(),
	HP = 1,
	moving = false,
	running = false,
	casting = false
}

var main : Node
var world : Node
var animationTree : AnimationTree
var animationPlayer : AnimationPlayer
var ACTION_DATA : Dictionary

func init(entityType: String, entityName: String, spawn: Vector2):
	world = get_parent()
	main = world.get_parent()
	animationPlayer = get_node("AnimationPlayer")
	animationTree = get_node("AnimationTree")
	ACTION_DATA = main.ACTION_DATA
	INFO["type"] = entityType
	INFO["name"] = entityName
	INFO["spawnPoint"] = spawn
	position = INFO["spawnPoint"]
	init_stats()
	STATUS["HP"] = STATS["maxHP"]

func init_stats():
	match INFO["type"]:
		"Hero":
			STATS["maxHP"] = 10
			STATS["baseSpeed"] = 96
			STATS["runMod"] = 1.5
		"Spirit":
			STATS["baseSpeed"] = 216
			STATS["runMod"] = 8
		"Enemy":
			match INFO["name"]:
				"Soldier":
					STATS["maxHP"] = 2
					STATS["baseSpeed"] = 48
					STATS["runMod"] = 1.5
	STATS["runSpeed"] = round(STATS["baseSpeed"] * STATS["runMod"])

func move():
	if STATUS["direction"] && !STATUS["casting"]:
		set_moving(true)
		update_animation()
	else: set_moving(false)
	if STATUS["moving"] :
		velocity = STATUS["direction"].normalized()*STATS["baseSpeed"]
		if STATUS["running"]:
			animationPlayer.speed_scale = STATS["runMod"]
			velocity = velocity * STATS["runMod"]
		else: animationPlayer.speed_scale = 1
	else: velocity = Vector2()
	move_and_slide()

func set_moving(value: bool):
		STATUS["moving"] = value
		animationTree["parameters/conditions/moving"] = value
		animationTree["parameters/conditions/idle"] = !value

func update_animation():
	animationTree["parameters/idle/blend_position"] = STATUS["direction"]
	animationTree["parameters/walk/blend_position"] = STATUS["direction"]

func load_action(actionName:String):
	var scene = load("res://scenes/actions/"+actionName+"/"+actionName+".tscn")
	var sceneNode = scene.instantiate()
	return sceneNode

func learn_action(actionKey: String):
	var newAction = load_action(actionKey)
	var learnable = true
	for known in INFO["knownActions"]:
		if known.key == newAction.key:
			learnable = false
	if learnable: INFO["knownActions"].push_back(newAction)

func learn_action_set(actionSet: Array):
	for i in actionSet.size():
		learn_action(actionSet[i])

func take_damage(amt : int):
	STATUS["HP"] -= amt
	if INFO["type"] == "Hero":
		main.hud.adjust_hp(-amt)
	if STATUS["HP"] <= 0: die()

func heal(amt: int):
	if STATUS["HP"] + amt < STATS["maxHP"]: STATUS["HP"] += amt
	else: STATUS["HP"] = STATS["maxHP"]
	if INFO["type"] == "Hero":
		main.hud.adjust_hp(amt)

func die():
	if INFO["type"] == "Hero":
		main.end_game()
	queue_free()
