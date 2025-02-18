extends Sprite2D

var hudTileset = preload("res://assets/image/HUD_tileset.png")

var heartIcon = Rect2(64, 0, 32, 32)
var damagedIcon = Rect2(96, 0, 32, 32)
var brokenIcon = Rect2(128, 0, 32, 32)
var dmgTimer : float = -1
var status : String

const dmgDelay :float = .5

func init():
	set_texture(hudTileset)
	scale = Vector2(0.8,0.8)
	region_enabled = true
	region_rect = heartIcon
	status = "heart"

func _physics_process(delta):
	if dmgTimer > 0:
		dmgTimer -= delta
	else: if dmgTimer != -1:
		region_rect = brokenIcon
		dmgTimer = -2

func damage_heart():
	region_rect = damagedIcon
	dmgTimer = dmgDelay

func heal_heart():
	region_rect = heartIcon
	dmgTimer = -1
