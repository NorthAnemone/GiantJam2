extends SceneTree

var failures := 0

func _initialize() -> void:
	run.call_deferred()

func check(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		push_error(message)

func run() -> void:
	var manager := root.get_node("GameManager")
	var world := Node2D.new()
	root.add_child(world)
	current_scene = world
	var target := Node2D.new()
	world.add_child(target)
	target.position = Vector2(500, 300)
	var previous_rate := 0.0
	var previous_speed := 0.0
	for second in range(71):
		manager.dayTimer = second
		var rate: float = manager.get_difficulty_multiplier()
		var speed: float = manager.get_hook_speed_multiplier()
		check(rate >= previous_rate and speed >= previous_speed, "Difficulty increases throughout the day")
		previous_rate = rate
		previous_speed = speed
	for sample in [0.0, 35.0, 70.0]:
		manager.dayTimer = sample
		var turret := (load("res://scenes/minigame/turret.tscn") as PackedScene).instantiate()
		turret.target = target
		world.add_child(turret)
		turret.set_process(false)
		var wait_time: float = turret.fire_rate / manager.get_difficulty_multiplier()
		var before := world.get_child_count()
		turret._process(wait_time - 0.01)
		check(world.get_child_count() == before, "Turret waits for its scaled firing interval")
		turret._process(0.02)
		check(world.get_child_count() == before + 1, "Turret fires at the scaled interval")
		var bullet := world.get_child(world.get_child_count()-1)
		bullet.set_process(false)
		bullet.position = Vector2(300, 300)
		bullet.direction = Vector2.RIGHT
		bullet._process(0.1)
		check(is_equal_approx(bullet.position.x, 300.0 + 22.0 * manager.get_hook_speed_multiplier()), "Flying hooks use current difficulty")
		bullet.queue_free()
		turret.queue_free()
		await process_frame
	manager.dayTimer = -10.0
	check(manager.get_difficulty_multiplier() == 0.5, "Difficulty clamps below day start")
	manager.dayTimer = 1000.0
	check(manager.get_difficulty_multiplier() == 2.0, "Difficulty clamps at day end")
	manager.begin_next_day()
	manager.timer.events.clear()
	manager.quota_display.events.clear()
	check(manager.get_difficulty_multiplier() == 0.5 and manager.get_hook_speed_multiplier() == 0.8, "Next day resets difficulty")
	manager.end_play()
	print("Difficulty ramp: %d failure(s)" % failures)
	quit(failures)
