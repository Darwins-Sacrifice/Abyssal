extends Node2D

func cast(caster:Entity, _target:Entity, _direction: Vector2):
	caster.heal(1)
