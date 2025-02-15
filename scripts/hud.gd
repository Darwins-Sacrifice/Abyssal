extends CanvasLayer

var hudTileset = preload("res://assets/image/HUD_tileset.png")

var main : Node2D
var hero : Entity

var hpBar : HBoxContainer
var hpIcon : Sprite2D
var hpBox = TextureRect

const hpBarLength = 256

func _ready():
	hpBar = HBoxContainer.new()
	hpIcon = Sprite2D.new()
	hpBox = TextureRect.new()
	hpBox.add_child(hpIcon)
	hpIcon.set_texture(hudTileset)
	hpIcon.region_enabled = true
	hpIcon.region_rect= Rect2(0, 0, 16, 16)
	add_child(hpBar)
	hpBar.position = Vector2(64,476)

func init(player : Entity):
	main = get_parent()
	hero = player
	adjust_max_hp(hero.maxHP)

func adjust_max_hp(maxHP:int):
	hpIcon.scale.x = hpBarLength/float(maxHP*hpIcon.region_rect.size.x)
	for box in hpBar.get_children():
		hpBar.remove_child(box)
	for i in maxHP:
		hpBar.add_child(hpBox.duplicate())
	hpBar.add_theme_constant_override("separation", int(hpIcon.region_rect.size.x*hpIcon.scale.x))
	
