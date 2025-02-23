extends Node2D

var key = "hurt_self"

func cast(caster:Entity, _target:Entity, _dir: Vector2):
	caster.take_damage(1)
