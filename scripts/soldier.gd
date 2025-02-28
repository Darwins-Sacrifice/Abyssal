extends Entity

func _ready():
	STATUS["targetPos"] = position
	STATUS["range"] = 50

func _physics_process(_delta):
	if position.distance_to(main.hero.position) > STATUS["range"]:
		var tween = create_tween()
		STATUS["targetPos"] = main.hero.position -(main.hero.position-position).normalized()*Vector2(STATUS["range"],STATUS["range"])
		tween.tween_property(self, "position", STATUS["targetPos"], position.distance_to(STATUS["targetPos"] )/STATS["baseSpeed"])
