extends Entity

var separation_radius = 80.0  # How far to check for nearby soldiers
var separation_strength = 2.0  # How much to avoid other soldiers
var wander_offset = Vector2.ZERO  # Random offset for movement variety
var wander_timer = 0.0

func _ready():
	call_deferred("_deferred_init")
	# Give each soldier a slightly different wander pattern
	wander_offset = Vector2(randf_range(-64, 64), randf_range(-64, 64))
	wander_timer = randf_range(0, 3.0)

func _deferred_init():
	init("Enemy", "Soldier", position)

func _physics_process(delta):
	if main != null && main.hero != null:
		var distance = position.distance_to(main.hero.position)

		if distance < INFO["vision"]:
			pathfind_to_hero(delta, distance)
		else:
			STATUS["direction"] = Vector2()
			STATUS["running"] = false
			move()

func pathfind_to_hero(delta: float, distance: float):
	var direction_to_hero: Vector2

	# If in attack range, go straight for the kill - no wandering
	if distance <= INFO["range"]:
		direction_to_hero = (main.hero.position - position).normalized()
	else:
		# Update wander offset periodically for movement variety when approaching
		wander_timer += delta
		if wander_timer > 3.0:
			wander_offset = Vector2(randf_range(-64, 64), randf_range(-64, 64))
			wander_timer = 0.0

		# Calculate direction to hero with wander offset
		var target_pos = main.hero.position + wander_offset
		direction_to_hero = (target_pos - position).normalized()

	# Add separation from other soldiers to avoid clustering
	var separation = get_separation_vector()

	# Combine hero-seeking and separation behaviors
	STATUS["direction"] = (direction_to_hero + separation * separation_strength).normalized()

	# Run when far away, walk when close
	if distance > INFO["range"] * 2:
		STATUS["running"] = true
	else:
		STATUS["running"] = false

	move()

func get_separation_vector() -> Vector2:
	var separation = Vector2.ZERO
	var nearby_count = 0

	# Check all entities in the world
	for entity in world.get_children():
		if entity == self or not entity is Entity:
			continue
		if entity.INFO["type"] != "Enemy":
			continue

		var dist = position.distance_to(entity.position)
		if dist < separation_radius and dist > 0:
			# Push away from nearby soldiers
			var away_dir = (position - entity.position).normalized()
			# Stronger push when closer
			var strength = 1.0 - (dist / separation_radius)
			separation += away_dir * strength
			nearby_count += 1

	if nearby_count > 0:
		separation = separation / nearby_count

	return separation
