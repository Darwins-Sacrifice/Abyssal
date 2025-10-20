extends CanvasLayer

# Preload scenes
var heart_scene = preload("res://scenes/heart.tscn")
var slot_scene = preload("res://scenes/slot.tscn")

var main : Node
var hero : Entity
var spirit : Entity
var slot : Sprite2D
var heart : Sprite2D


var heartBar : HBoxContainer
var heartBox : TextureRect
var heartBoxes : Array
var slotBar : HBoxContainer
var slotBox : TextureRect
var selectedSlot : int

var spiritSlotBar : VBoxContainer
var spiritSlotBox : TextureRect
var spiritSelectedSlot : int

const heartBarLength = 256
const heartBarPos = Vector2(64,476)
const slotBarPos = Vector2(380,508)
const spiritSlotBarPos = Vector2(928,64)

const tRes = 32
const numActions = 5
const slotSeparation = 5

func init():
	main = get_parent()
	hero = main.hero
	spirit = main.spirit

	heartBar = HBoxContainer.new()
	add_child(heartBar)
	heartBar.position = heartBarPos
	heartBox = TextureRect.new()
	heart = heart_scene.instantiate()
	heartBox.add_child(heart)
	heart.init()
	heartBar.add_theme_constant_override("separation", int(tRes*heart.scale.x))
	adjust_max_hp(hero.STATS["maxHP"])
	adjust_hp(hero.STATS["maxHP"])

	slotBar = HBoxContainer.new()
	add_child(slotBar)
	slotBar.position = slotBarPos
	slotBox = TextureRect.new()
	slot = slot_scene.instantiate()
	slotBox.add_child(slot)
	slot.init()
	slotBar.add_theme_constant_override("separation", int(tRes+slotSeparation))

	for i in numActions:
		var newBox= slotBox.duplicate()
		slotBar.add_child(newBox)
	selectedSlot = hero.STATUS["activeSlot"]
	select_slot(selectedSlot)

	# Spirit action bar (vertical)
	spiritSlotBar = VBoxContainer.new()
	add_child(spiritSlotBar)
	spiritSlotBar.position = spiritSlotBarPos
	spiritSlotBox = TextureRect.new()
	var spiritSlot = slot_scene.instantiate()
	spiritSlotBox.add_child(spiritSlot)
	spiritSlot.init()
	spiritSlotBar.add_theme_constant_override("separation", int(tRes+slotSeparation))

	for i in numActions:
		var newBox = spiritSlotBox.duplicate()
		spiritSlotBar.add_child(newBox)
	spiritSelectedSlot = spirit.STATUS["activeSlot"]
	select_spirit_slot(spiritSelectedSlot)

func _physics_process(_delta):
	if hero.STATUS["HP"] == 1: shake_hp()
	else: if heartBoxes != []: heartBoxes[0].position = Vector2(0,0)

func adjust_max_hp(total:int):
	var visibleHealth = heartBar.get_children().size()
	if total > visibleHealth:
		for i in total-visibleHealth:
			var newBox= heartBox.duplicate()
			var newHeart= newBox.get_node("Heart")
			newHeart.region_rect = newHeart.brokenIcon
			newHeart.dmgTimer = -2
			heartBar.add_child(newBox)
	else: if total < visibleHealth:
		for i in visibleHealth-total:
			heartBar.remove_child(heartBar.get_child(-1))
	heartBoxes = heartBar.get_children()

func adjust_hp(amt: int):
	if amt < 0:
		var dmg = -amt
		var i = heartBoxes.size()-1
		while i >= 0 && dmg > 0:
			if heartBoxes[i].get_node("Heart").dmgTimer == -1:
				heartBoxes[i].get_node("Heart").damage_heart()
				dmg -= 1
			i -= 1
	if amt > 0: 
		var heal = amt
		var i = 0
		while i <= heartBoxes.size()-1 && heal > 0:
			if heartBoxes[i].get_node("Heart").dmgTimer != -1:
				heartBoxes[i].get_node("Heart").heal_heart()
				heal -= 1
			i += 1

func shake_hp():
	heartBoxes[0].position.x = sin(main.clock*50)*2
	heartBoxes[0].position.y = sin(main.clock*20)*5

func select_slot(i: int):
	slotBar.get_children()[selectedSlot-1].get_node("Slot").unselect()
	selectedSlot = i
	slotBar.get_children()[selectedSlot-1].get_node("Slot").select()

func get_slot_sprite(i: int):
	var sprite = slotBar.get_children()[i-1].get_node("Slot").get_node("actionSprite")
	return sprite

func select_spirit_slot(i: int):
	spiritSlotBar.get_children()[spiritSelectedSlot-1].get_node("Slot").unselect()
	spiritSelectedSlot = i
	spiritSlotBar.get_children()[spiritSelectedSlot-1].get_node("Slot").select()

func get_spirit_slot_sprite(i: int):
	var sprite = spiritSlotBar.get_children()[i-1].get_node("Slot").get_node("actionSprite")
	return sprite
