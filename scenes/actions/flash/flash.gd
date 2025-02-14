extends Node2D

func cast(caster:Entity, _target:Entity, direction: Vector2):
	var dist = caster.baseSpeed * 3
	caster.position += direction*dist
