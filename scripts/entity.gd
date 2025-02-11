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
    hitbox.shape.size = sprite.sprite_frames.get_frame_texture("down",0).get_size()
    add_child(hitbox)
    visible = true
    sprite.speed_scale = animate_speed
    match entity_type:
        "player":
            base_speed = 200
            run_speed = 400
        "spirit":
            base_speed = 300
            run_speed = 400


func _physics_process(_delta):
    match direction:
        Vector2(0,0):
            sprite.stop()
        Vector2(0,-1),Vector2(-1,-1):
            if moving: sprite.play("up")
            else:sprite.play("up_idle")
        Vector2(0,1), Vector2(1,1):
            if moving: sprite.play("down")
            else:sprite.play("down_idle")
        Vector2(-1,0),Vector2(1,-1):
            if moving: sprite.play("left")
            else:sprite.play("left_idle")
        Vector2(1,0), Vector2(-1,1):
            if moving: sprite.play("right")
            else:sprite.play("right_idle")
    move_and_slide()

func set_speed(pace :int):
    speed = pace
    sprite.speed_scale = float(pace)/float(base_speed)
