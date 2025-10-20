extends Node2D

var key = "flash"
var success = true
var raycast : RayCast2D
var flashVect = Vector2()

func cast(caster:Entity, _target:Entity, dir: Vector2):
	var dist = caster.STATS["baseSpeed"] * 2
	flashVect = dir*dist
	raycast = caster.get_node("Raycast")
	raycast.position = caster.get_node("Collider").position
	raycast.target_position = raycast.position + flashVect
	raycast.force_raycast_update()
	if raycast.is_colliding():
		flashVect = raycast.get_collision_point()-caster.position
		if flashVect.length() < caster.STATS["baseSpeed"]:
			flashVect = Vector2()
	if flashVect:
		create_ghost_trail(caster)
		caster.position += flashVect
	else: success = false
	return success

func create_ghost_trail(caster:Entity):
	var sprite = caster.get_node("Sprite")
	var ghost_count = int(flashVect.length() / 8)
	for i in range(ghost_count):
		var t = float(i) / max(ghost_count - 1, 1)
		var eased_t = ease(t, 0.5)  # Ease in - bunches up towards the end
		var ghost = AnimatedSprite2D.new()
		ghost.sprite_frames = sprite.sprite_frames
		ghost.animation = sprite.animation
		ghost.frame = sprite.frame
		ghost.offset = sprite.offset
		# Use local position since ghost is child of caster
		ghost.position = Vector2.ZERO.lerp(flashVect, eased_t) - flashVect
		ghost.modulate = Color(1, 1, 1, 0.3)
		ghost.scale = Vector2.ONE
		caster.add_child(ghost)

		var delay = t * 0.1

		var tween = caster.world.create_tween()
		tween.tween_interval(delay)
		tween.set_parallel(true)
		tween.tween_property(ghost, "modulate:a", 0, 0.5)
		tween.tween_property(ghost, "scale", Vector2.ONE * 0.5, 0.5)
		tween.tween_property(ghost, "position", Vector2.ZERO, 0.5)  # Converge to caster's origin
		tween.chain().tween_callback(ghost.queue_free)
