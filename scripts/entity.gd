extends CharacterBody2D
class_name Entity

# Layers
# 1 - Hero
# 2 - Enemy
# 3 - NPC
# 4 - Obstacles
# 5 - Spirit

var entityType : String
var sprite : AnimatedSprite2D
var hitbox : CollisionShape2D
var spawnPoint : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var baseSpeed : int
var runSpeed : int
var moving : bool = false
var running : bool = false
var maxHP: int = 1
var hp : int = 1

func init(type: String, spawn: Vector2, image: SpriteFrames):
	entityType = type
	spawnPoint = spawn
	position = spawnPoint
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = image
	sprite.play("down_idle")
	sprite.speed_scale = 1
	add_child(sprite)
	hitbox = CollisionShape2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.shape.size = sprite.sprite_frames.get_frame_texture("down_idle",0).get_size()
	add_child(hitbox)
	visible = true
	match entityType:
		"hero":
			maxHP = 10
			baseSpeed = 96
			set_collision_layer_value(1,true)
			for i in [2,3,4]:
				set_collision_mask_value(i,true)
		"spirit":
			baseSpeed = 256
			set_collision_layer_value(5,true)
	runSpeed = round(baseSpeed * 1.5)
	heal(maxHP)

func move():
	move_and_slide()
	if running: sprite.speed_scale = float(runSpeed)/float(baseSpeed)
	else: sprite.speed_scale = 1
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

func take_damage(dmg : int):
	hp -= dmg
	if hp <= 0: die()

func heal(amt: int):
	if hp + amt < maxHP: hp += amt
	else: hp = maxHP

func die():
	if entityType == "hero":
		get_parent().end_game()
	queue_free()

	
