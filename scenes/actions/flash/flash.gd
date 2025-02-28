extends Node2D

var key = "flash"
var success = true
var raycast : RayCast2D

func cast(caster:Entity, _target:Entity, dir: Vector2):
	var dist = caster.STATS["baseSpeed"] * 3
	var flashVect = dir*dist
	raycast = caster.get_node("Raycast")
	raycast.position = caster.get_node("Collider").position
	raycast.target_position = raycast.position + flashVect
	raycast.force_raycast_update()
	if raycast.is_colliding():
		flashVect = raycast.get_collision_point()-caster.position
		if flashVect.length() < caster.STATS["baseSpeed"]:
			flashVect = Vector2()
	if flashVect:
		caster.position += flashVect
	else: success = false
	return success
