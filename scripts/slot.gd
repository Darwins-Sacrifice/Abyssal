extends Sprite2D

var hudTileset = preload("res://assets/image/HUD_tileset.png")
var actionTileset = preload("res://assets/image/Action_tileset.png")

@onready var ACTION_DATA = DATABASE.ACTION_DATA
var actionSprite : Sprite2D
var cooldownLabel : Label
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

	# Add cooldown label
	cooldownLabel = Label.new()
	cooldownLabel.set_name("cooldownLabel")
	cooldownLabel.add_theme_font_size_override("font_size", 14)
	cooldownLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cooldownLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cooldownLabel.set_position(Vector2(-16, -16))
	cooldownLabel.set_size(Vector2(32, 32))
	cooldownLabel.visible = false
	add_child(cooldownLabel)

func select():
	region_rect = selectedIcon

func unselect():
	region_rect = unselectedIcon
