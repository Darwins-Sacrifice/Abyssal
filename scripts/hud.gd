extends CanvasLayer

# Preload scenes
var heart_scene = preload("res://scenes/heart.tscn")

var main : Node2D
var hero : Entity
var heart : Sprite2D
var hps : Array

var hpBar : HBoxContainer
var hpBox : TextureRect

const hpBarLength = 256
const hpBarPos = Vector2(64,476)

func init(player : Entity):
	main = get_parent()
	hero = player
	hpBar = HBoxContainer.new()
	add_child(hpBar)
	hpBar.position = hpBarPos
	hpBox = TextureRect.new()
	heart = heart_scene.instantiate()
	hpBox.add_child(heart)
	heart.init()
	hpBar.add_theme_constant_override("separation", int(heart.region_rect.size.x*heart.scale.x))
	adjust_max_hp(hero.maxHP)
	hero.heal(hero.maxHP)

func _physics_process(_delta):
	if hero.hp == 1:
		hps[0].position.x = sin(main.clock*50)*2
		hps[0].position.y = sin(main.clock*20)*5
	else: if hps != [] : hps[0].position = Vector2(0,0)

func adjust_max_hp(total:int):
	var visibleHealth = hpBar.get_children().size()
	if total > visibleHealth:
		for i in total-visibleHealth:
			var newBox= hpBox.duplicate()
			var newHeart= newBox.get_node("heart")
			newHeart.region_rect = newHeart.brokenIcon
			newHeart.dmgTimer = -2
			hpBar.add_child(newBox)
	else: if total < visibleHealth:
		for i in visibleHealth-total:
			hpBar.remove_child(hpBar.get_child(-1))
	hps = hpBar.get_children()

func adjust_hp(amt: int):
	if amt < 0:
		var dmg = -amt
		var i = hps.size()-1
		while i >= 0 && dmg > 0:
			if hps[i].get_node("heart").dmgTimer == -1:
				hps[i].get_node("heart").damage_heart()
				dmg -= 1
			i -= 1
	if amt > 0: 
		var heal = amt
		var i = 0
		while i <= hps.size()-1 && heal > 0:
			if hps[i].get_node("heart").dmgTimer != -1:
				hps[i].get_node("heart").heal_heart()
				heal -= 1
			i += 1
