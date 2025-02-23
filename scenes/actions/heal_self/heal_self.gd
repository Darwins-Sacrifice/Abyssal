extends Node2D

var key = "heal_self"

func cast(caster:Entity, _target:Entity, _dir: Vector2):
	caster.heal(1)
