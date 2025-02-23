extends CharacterBody2D
class_name Entity

var INFO = {  #Entity Information - type, name, knownActions, spawnPoint
	type = "_",
	name = "_",
	knownActions = [],
	spawnPoint = Vector2()
	}

var STATS = { #Entity Stats - maxHP, HP, baseSpeed, runSpeed, runMod
	maxHP = 1,
	HP = 1,
	baseSpeed = 0,
	runSpeed = 0,
	runMod = 1
}

var STATUS = { #Entity Status - moving, running, direction
	moving = false,
	running = false,
	direction = Vector2()
}

var main : Node
var ACTION_DATA : Dictionary

func init(entityType: String, entityName: String, spawn: Vector2):
	main = get_parent()
	ACTION_DATA = main.ACTION_DATA
	INFO["type"] = entityType
	INFO["name"] = entityName
	INFO["spawnPoint"] = spawn
	position = INFO["spawnPoint"]
	$Sprite.play("down_idle")
	match INFO["type"]:
		"Hero":
			STATS["maxHP"] = 10
			STATS["baseSpeed"] = 96
			STATS["runSpeed"] = round(float(STATS["baseSpeed"]) * 1.5)
		"Spirit":
			STATS["baseSpeed"] = 216
			STATS["runSpeed"] = round(float(STATS["baseSpeed"]) * 8)
	STATS["runMod"] = float(STATS["runSpeed"])/float(STATS["baseSpeed"])
	STATS["HP"] = STATS["maxHP"]

func move():
	if STATUS["running"]:
		$Sprite.speed_scale = STATS["runMod"]
		velocity = velocity * STATS["runMod"]
	else: $Sprite.speed_scale = 1
	move_and_slide()
	
	match STATUS["direction"]:
		Vector2(0,-1):
			if STATUS["moving"]: $Sprite.play("up")
			else:$Sprite.play("up_idle")
		Vector2(0,1), Vector2(0,0):
			if STATUS["moving"]: $Sprite.play("down")
			else:$Sprite.play("down_idle")
		Vector2(-1,0),Vector2(-1,-1),Vector2(-1,1):
			if STATUS["moving"]: $Sprite.play("left")
			else:
				$Sprite.play("left_idle")
				STATUS["direction"] = Vector2(-1,0)
		Vector2(1,0), Vector2(1,1),Vector2(1,-1):
			if STATUS["moving"]: $Sprite.play("right")
			else:
				$Sprite.play("right_idle")
				STATUS["direction"] = Vector2(1,0)

func load_action(actionName:String):
	var scene = load("res://scenes/actions/"+actionName+"/"+actionName+".tscn")
	var sceneNode = scene.instantiate()
	return sceneNode

func take_damage(amt : int):
	STATS["HP"] -= amt
	if INFO["type"] == "Hero":
		main.hud.adjust_hp(-amt)
	if STATS["HP"] <= 0: die()

func heal(amt: int):
	if STATS["HP"] + amt < STATS["maxHP"]: STATS["HP"] += amt
	else: STATS["HP"] = STATS["maxHP"]
	if INFO["type"] == "Hero":
		main.hud.adjust_hp(amt)

func die():
	if INFO["type"] == "Hero":
		main.end_game()
	queue_free()
