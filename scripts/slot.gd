extends Sprite2D

var database_scene = preload("res://scenes/DATABASE.tscn")
var hudTileset = preload("res://assets/image/HUD_tileset.png")
var actionTileset = preload("res://assets/image/Action_tileset.png")

var ACTION_DATA = database_scene.instantiate().ACTION_DATA
var actionSprite : Sprite2D
var actionImage = Rect2(0, 0, tRes, tRes)
var unselectedIcon = Rect2(5*tRes, 0, tRes, tRes)
var selectedIcon = Rect2(6*tRes, 0, tRes, tRes)

const tRes = 32

func init():
	set_texture(hudTileset)
	region_enabled = true
	region_rect = unselectedIcon
	actionSprite = Sprite2D.new()
	actionSprite.set_name("actionSprite")
	add_child(actionSprite)
	actionSprite.set_texture(actionTileset)
	actionSprite.region_enabled = true
	actionSprite.region_rect = actionImage

func select():
	region_rect = selectedIcon

func unselect():
	region_rect = unselectedIcon
