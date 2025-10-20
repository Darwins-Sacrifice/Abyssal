extends Area2D
class_name Hurtbox

func _on_area_entered(hitbox: Hitbox):
	var parent = get_parent()
	if hitbox != null:
		parent.take_damage(hitbox.damage)
		apply_knockback(parent, hitbox)

func apply_knockback(parent: Entity, hitbox: Hitbox):
	var knockback_dir = (parent.global_position - hitbox.global_position).normalized()
	var knockback_dist = 32
	var target_pos = parent.global_position + (knockback_dir * knockback_dist)

	var tween = parent.create_tween()
	tween.tween_property(parent, "global_position", target_pos, 0.15)