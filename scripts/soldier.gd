extends Entity

func _ready():
	call_deferred("_deferred_init")

func _deferred_init():
	init("Enemy", "Soldier", position)

func _physics_process(_delta):
	if main != null && main.hero != null:
		var distance = position.distance_to(main.hero.position)

		if distance < INFO["vision"]:
			STATUS["direction"] = (main.hero.position - position).normalized()
			if distance > INFO["range"]*2:
				STATUS["running"] = true
			else:
				STATUS["running"] = false
			move()
		else:
			STATUS["direction"] = Vector2()
			STATUS["running"] = false
			move()
