extends CharacterBody2D
class_name Entity

# Layers
# 1 - Hero
# 2 - Enemy
# 3 - NPC
# 4 - Obstacles
# 5 - Spirit

var entity_type : String
var sprite : AnimatedSprite2D
var hitbox : CollisionShape2D
var spawn_point : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var base_speed : int
var run_speed : int
var moving : bool = false
var running : bool = false
var hp : int = 1

func init(type: String, spawn: Vector2, image: SpriteFrames):
	entity_type = type
	spawn_point = spawn
	position = spawn_point
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
	match entity_type:
		"hero":
			hp = 10
			base_speed = 200
			run_speed = 400
			set_collision_layer_value(1,true)
			for i in [2,3,4]:
				set_collision_mask_value(i,true)
		"spirit":
			base_speed = 300
			run_speed = 400
			set_collision_layer_value(5,true)

func move():
	move_and_slide()
	if running: sprite.speed_scale = float(run_speed)/float(base_speed)
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

func load_action(action_name:String):
	var scene = load("res://scenes/actions/"+action_name+"/"+action_name+".tscn")
	var scene_node = scene.instantiate()
	add_child(scene_node)
	return scene_node

func take_damage(dmg : int):
	hp -= dmg
	if hp <= 0: die()

func die():
	if entity_type == "hero":
		get_parent().end_game()
	queue_free()

	
