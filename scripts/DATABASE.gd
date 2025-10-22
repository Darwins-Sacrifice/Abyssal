extends Node

var actionTileset = preload("res://assets/image/Action_tileset.png")

const tRes = 32

var ACTION_DATA = {  # All Actions In Game - title, row, column, targeted, tooltip, cooldown, region, icon
	nothing = {
		title = "Nothing",
		row = 1,
		column = 1,
		targeted = false,
		tooltip = "Does nothing.",
		cooldown = 0.0
	},
	flash = {
		title = "Flash",
		row = 1,
		column = 2,
		targeted = false,
		tooltip = "Instantly teleport forward a short distance increased by ability level.",
		cooldown = 3.0
	},
	heal_self = {
		title = "Heal",
		row = 1,
		column = 4,
		targeted = false,
		tooltip = "Heal the caster by 1 hp.",
		cooldown = 5.0
	},
	hero_heal = {
		title = "Heal Hero",
		row = 1,
		column = 4,
		targeted = false,
		tooltip = "Heal the hero by 1 hp.",
		cooldown = 5.0
	},
	hurt_self = {
		title = "Hurt Self",
		row = 1,
		column = 3,
		targeted = false,
		tooltip = "Damage the caster by 1 hp.",
		cooldown = 1.0
	},
	raise_max_hp = {
		title = "Gain Max HP",
		row = 1,
		column = 5,
		targeted = false,
		tooltip = "Raise the caster's max hp by 1 hp permanently",
		cooldown = 10.0
	},
	slash = {
		title = "Sword Attack",
		row = 1,
		column = 6,
		targeted = false,
		tooltip = "Slash sword in forward direction",
		cooldown = 1.5
	}
}

func _ready():
	#ACTION_DATA SETUP
	var sprite = Sprite2D.new()
	sprite.set_texture(actionTileset)
	sprite.region_enabled = true
	for key in ACTION_DATA.keys():
		ACTION_DATA[key]["region"] = Rect2((ACTION_DATA[key].column-1)*tRes,(ACTION_DATA[key].row-1)*tRes,tRes,tRes)
		var icon = sprite.duplicate()
		icon.region_rect = ACTION_DATA[key]["region"]
		ACTION_DATA[key]["icon"] = icon
	sprite.queue_free()
