extends Area2D
class_name Hurtbox

func _on_area_entered(hitbox: Hitbox):
	var parent = get_parent()
	if hitbox != null:
		parent.take_damage(hitbox.damage)
		apply_knockback(parent, hitbox)

func apply_knockback(parent: Entity, hitbox: Hitbox):
	var attacker = hitbox.get_parent()
	var knockback_dir = (parent.global_position - attacker.global_position).normalized()
	var knockback_dist = 32
	var knockback_vect = knockback_dir * knockback_dist

	var raycast = parent.get_node("Raycast")
	raycast.position = parent.get_node("Collider").position
	raycast.target_position = knockback_vect
	raycast.force_raycast_update()

	if raycast.is_colliding():
		knockback_vect = raycast.get_collision_point() - parent.position
		if knockback_vect.length() < 8:
			knockback_vect = Vector2()

	if knockback_vect:
		var tween = parent.create_tween()
		tween.tween_property(parent, "position", parent.position + knockback_vect, 0.15)
