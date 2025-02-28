extends Node2D

var key = "raise_max_hp"
var success = true

func cast(caster:Entity, _target:Entity, _dir: Vector2):
	caster.set_max_hp(caster.STATS["maxHP"]+1)
	return success
