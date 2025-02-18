extends Node2D

var level : int
var tooltip = ""

func cast(caster:Entity, _target:Entity, _direction: Vector2):
	caster.heal(level)
