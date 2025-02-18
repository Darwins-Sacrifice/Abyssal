extends Sprite2D

var hudTileset = preload("res://assets/image/HUD_tileset.png")

var heartIcon = Rect2(2*tRes, 0, tRes, tRes)
var damagedIcon = Rect2(3*tRes, 0, tRes, tRes)
var brokenIcon = Rect2(4*tRes, 0, tRes, tRes)
var dmgTimer : float = -1

const tRes = 32
const dmgDelay :float = .5

func init():
	set_texture(hudTileset)
	scale = Vector2(0.8,0.8)
	region_enabled = true
	region_rect = heartIcon

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
