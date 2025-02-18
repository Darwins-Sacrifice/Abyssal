extends Node2D

var level : int
var tooltip = "Instantly teleport forward a short distance increased by ability level"

func cast(caster:Entity, _target:Entity, direction: Vector2):
	var dist = caster.baseSpeed * (2+level)
	caster.position += direction*dist
