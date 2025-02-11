extends CharacterBody2D
class_name Entity

var entity_type : String
var sprite : AnimatedSprite2D
var hitbox : CollisionShape2D
var direction : Vector2
var base_speed : int
var run_speed : int
var speed : int = 0
var animate_speed : int = 1
var sprinting : bool = false
var moving : bool = false

func init(type: String, spawn_point: Vector2, image: SpriteFrames):
	entity_type = type
	position = spawn_point
	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = image
	add_child(sprite)
	hitbox = CollisionShape2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.shape.size = sprite.sprite_frames.get_frame_texture("idle_down",0).get_size()
	add_child(hitbox)
	visible = true
	sprite.speed_scale = animate_speed
	match entity_type:
		"hero":
			base_speed = 200
			run_speed = 400
			set_collision_layer_value(1,true)
			set_collision_mask_value(1,true)
		"spirit":
			base_speed = 300
			run_speed = 400
			set_collision_layer_value(2,true)
			set_collision_mask_value(2,true)

func set_speed(pace :int):
	speed = pace
	sprite.speed_scale = float(pace)/float(base_speed)
