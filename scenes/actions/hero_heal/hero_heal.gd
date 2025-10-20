extends Node2D

var key = "hero_heal"
var success = true

func cast(caster:Entity, _target:Entity, _dir: Vector2):
	var hero = caster.main.hero
	if hero.STATUS["HP"] < hero.STATS["maxHP"]:
		hero.heal(1)
	else: success = false
	return success
