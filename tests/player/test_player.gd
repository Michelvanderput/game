extends TestCase

const Stat := PlayerStats.Stat


func _make_player() -> Player:
	var player := (load("res://src/player/player.tscn") as PackedScene).instantiate() as Player
	player.position = Vector2(10000.0, 10000.0)
	add_child(player)
	return player


func after_each() -> void:
	for action: StringName in [&"shoot_right", &"shoot_up", &"move_left"]:
		Input.action_release(action)


func test_build_shot_uses_stats() -> void:
	var player := _make_player()
	var spec := player.build_shot(Vector2.UP)
	assert_eq(spec.direction, Vector2.UP)
	assert_almost_eq(spec.speed, 7.0 * Grid.TILE_SIZE)
	assert_almost_eq(spec.max_distance, 6.5 * Grid.TILE_SIZE)
	assert_almost_eq(spec.damage, 3.0)
	player.stats.add_modifier(StatModifier.create(Stat.DAMAGE, 0.7))
	assert_almost_eq(player.build_shot(Vector2.UP).damage, 3.7)


func test_fire_rate_matches_stat() -> void:
	var player := _make_player()
	var shots: Array[int] = [0]
	player.shot_fired.connect(func(_spec: ShotSpec) -> void: shots[0] += 1)
	Input.action_press(&"shoot_right")
	step_physics([player], 120)  # 2 s at 2.5 shots/s: t = 0, 0.4, 0.8, 1.2, 1.6
	assert_eq(shots[0], 5)
	assert_eq(player.facing, Vector2.RIGHT, "Pit faces the shooting direction")
	player.stats.add_modifier(StatModifier.create(Stat.FIRE_RATE, 2.5))
	shots[0] = 0
	step_physics([player], 120)  # 5 shots/s
	assert_true(shots[0] >= 9 and shots[0] <= 11, "about 10 shots, got %d" % shots[0])


func test_to_cardinal_snaps_to_four_directions() -> void:
	assert_eq(Player.to_cardinal(Vector2(0.9, 0.2)), Vector2.RIGHT)
	assert_eq(Player.to_cardinal(Vector2(-0.1, -0.8)), Vector2.UP)
	assert_eq(Player.to_cardinal(Vector2(0.7, 0.7)), Vector2.RIGHT, "ties go horizontal")
	assert_eq(Player.to_cardinal(Vector2.ZERO), Vector2.ZERO)


func test_moves_and_accelerates() -> void:
	var player := _make_player()
	Input.action_press(&"move_left")
	step_physics([player], 1)
	var first_speed := player.velocity.length()
	assert_true(first_speed > 0.0 and first_speed < player.base_move_speed, "accelerates, not instant")
	step_physics([player], 30)
	assert_almost_eq(player.velocity.x, -player.base_move_speed, 0.01, "reaches full speed")
	assert_eq(player.facing, Vector2.LEFT)
	Input.action_release(&"move_left")
	step_physics([player], 30)
	assert_almost_eq(player.velocity.length(), 0.0, 0.01, "stops")
