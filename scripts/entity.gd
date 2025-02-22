extends CharacterBody2D
class_name Entity

# Layers
# 1 - Hero
# 2 - Enemy
# 3 - NPC
# 4 - Obstacles
# 5 - Spirit

var main : Node
var entityType : String
var sprite : AnimatedSprite2D
var hitbox : CollisionShape2D
var knownActions : Array
var spawnPoint : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var baseSpeed : int
var runSpeed : int
var moving : bool = false
var running : bool = false
var maxHP: int = 1
var hp : int = 1

func init(type: String, spawn: Vector2):
	main = get_parent()
	sprite = $sprite
	hitbox = $hitbox
	entityType = type
	spawnPoint = spawn
	position = spawnPoint
	sprite.play("down_idle")
	match entityType:
		"hero":
			maxHP = 10
			baseSpeed = 96
			runSpeed = round(float(baseSpeed) * 1.5)
		"spirit":
			baseSpeed = 216
			runSpeed = baseSpeed * 8
	hp = maxHP

func move():
	if running:
		sprite.speed_scale = float(runSpeed)/float(baseSpeed)
		velocity = velocity * float(runSpeed)/float(baseSpeed)
	else: sprite.speed_scale = 1
	move_and_slide()
	

	match direction:
		Vector2(0,-1):
			if moving: sprite.play("up")
			else:sprite.play("up_idle")
		Vector2(0,1), Vector2(0,0):
			if moving: sprite.play("down")
			else:sprite.play("down_idle")
		Vector2(-1,0),Vector2(-1,-1),Vector2(-1,1):
			if moving: sprite.play("left")
			else:
				sprite.play("left_idle")
				direction = Vector2(-1,0)
		Vector2(1,0), Vector2(1,1),Vector2(1,-1):
			if moving: sprite.play("right")
			else:
				sprite.play("right_idle")
				direction = Vector2(1,0)

func load_action(actionName:String):
	var scene = load("res://scenes/actions/"+actionName+"/"+actionName+".tscn")
	var sceneNode = scene.instantiate()
	add_child(sceneNode)
	return sceneNode

func take_damage(amt : int):
	hp -= amt
	if entityType == "hero":
		main.hud.adjust_hp(-amt)
	if hp <= 0: die()

func heal(amt: int):
	if hp + amt < maxHP: hp += amt
	else: hp = maxHP
	if entityType == "hero":
		main.hud.adjust_hp(amt)

func die():
	if entityType == "hero":
		main.end_game()
	queue_free()
