extends Node2D

var level : int
var tooltip = ""

func cast(caster:Entity, _target:Entity, _direction: Vector2):
	caster.set_max_hp(caster.maxHP+level)

