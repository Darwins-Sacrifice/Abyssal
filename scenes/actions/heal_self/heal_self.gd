extends Node2D

var key = "heal_self"
var success = true

func cast(caster:Entity, _target:Entity, _dir: Vector2):
	if caster.STATUS["HP"] < caster.STATS["maxHP"]:
		caster.heal(1)
	else: success = false
	return success
