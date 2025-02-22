extends Node2D

var actionTileset = preload("res://assets/image/Action_tileset.png")

var columns : int
var rows : int
const tRes = 32


var DATA = {  # All Actions In Game
	nothing = { 
		title = "Nothing",
		row = 1,
		column = 1,
		tooltip = "Does nothing."
	},
	flash = { 
		title = "Flash",
		row = 1,
		column = 2,
		tooltip = "Instantly teleport forward a short distance increased by ability level."
	},
	heal_self = { 
		title = "Heal",
		row = 1,
		column = 4,
		tooltip = "Heal the caster by 1 hp."
	},
	hurt_self = { 
		title = "Hurt Self",
		row = 1,
		column = 3,
		tooltip = "Damage the caster by 1 hp."
	},
	raise_max_hp = { 
		title = "Gain Max HP",
		row = 1,
		column = 5,
		tooltip = "Raise the caster's max hp by 1 hp permanently"
	}
}

func init():
	columns = round(float(actionTileset.get_width())/tRes)
	rows = round(float(actionTileset.get_height())/tRes)
	var sprite = Sprite2D.new()
	sprite.set_texture(actionTileset)
	sprite.region_enabled = true
	for key in DATA.keys():
		DATA[key]["region"] = Rect2((DATA[key].column-1)*tRes,(DATA[key].row-1)*tRes,tRes,tRes)
		var icon = sprite.duplicate()
		icon.region_rect = DATA[key]["region"]
		DATA[key]["icon"] = icon
