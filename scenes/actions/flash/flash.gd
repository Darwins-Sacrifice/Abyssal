extends Node2D

var dist = 200

func cast(caster:Entity, target:Entity, direction: Vector2):
	caster.position += direction*dist
	print_debug("I did FLASH!")
