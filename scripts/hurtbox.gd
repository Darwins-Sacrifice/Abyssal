extends Area2D
class_name Hurtbox

var knockback_strength = 320  # Initial velocity

func _on_area_entered(area: Area2D):
	if area is Hitbox:
		var hitbox = area as Hitbox
		var parent = get_parent()
		parent.take_damage(hitbox.damage)
		apply_knockback(parent, hitbox)

func apply_knockback(parent: Entity, hitbox: Hitbox):
	var attacker = hitbox.get_parent()
	var knockback_dir = (parent.global_position - attacker.global_position).normalized()
	parent.knockback_velocity = knockback_dir * knockback_strength
	parent.STATUS["knockback"] = true
