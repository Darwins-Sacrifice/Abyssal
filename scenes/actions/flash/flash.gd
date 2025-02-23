extends Node2D

var key = "flash"
var raycast = RayCast2D

func cast(caster:Entity, _target:Entity, dir: Vector2):
	var dist = caster.STATS["baseSpeed"] * 3
	var flashVect = dir*dist
	raycast = caster.get_node("Raycast")
	raycast.target_position = flashVect+(dir*16)
	if raycast.is_colliding():
		flashVect = Vector2()
	caster.position += flashVect
