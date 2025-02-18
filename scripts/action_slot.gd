extends Sprite2D

var hudTileset = preload("res://assets/image/HUD_tileset.png")

var unselectedIcon = Rect2(5*tRes, 0, tRes, tRes)
var selectedIcon = Rect2(6*tRes, 0, tRes, tRes)

const tRes = 32

func init():
	set_texture(hudTileset)
	region_enabled = true
	region_rect = unselectedIcon