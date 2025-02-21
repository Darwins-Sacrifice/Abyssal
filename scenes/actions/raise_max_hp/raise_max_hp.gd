extends Node2D

func cast(caster:Entity, _target:Entity, _direction: Vector2):
	caster.set_max_hp(caster.maxHP+1)

