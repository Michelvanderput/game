extends TestCase

const Stat := PlayerStats.Stat


func test_start_values_match_gdd() -> void:
	var stats := load("res://data/player/pit_stats.tres") as PlayerStats
	assert_almost_eq(stats.get_value(Stat.MAX_FLAMES), 3.0)
	assert_almost_eq(stats.get_value(Stat.DAMAGE), 3.0)
	assert_almost_eq(stats.get_value(Stat.FIRE_RATE), 2.5)
	assert_almost_eq(stats.get_value(Stat.RANGE), 6.5)
	assert_almost_eq(stats.get_value(Stat.SHOT_SPEED), 7.0)
	assert_almost_eq(stats.get_value(Stat.MOVE_SPEED), 1.0)
	assert_almost_eq(stats.get_value(Stat.LUCK), 0.0)
	assert_almost_eq(stats.get_value(Stat.GLOW), 3.5)


func test_formula_adds_then_multiplies() -> void:
	var stats := PlayerStats.new()
	stats.add_modifier(StatModifier.create(Stat.DAMAGE, 0.7))
	stats.add_modifier(StatModifier.create(Stat.DAMAGE, 0.3))
	stats.add_modifier(StatModifier.create(Stat.DAMAGE, 0.0, 1.5))
	stats.add_modifier(StatModifier.create(Stat.DAMAGE, 0.0, 2.0))
	# (3.0 + 0.7 + 0.3) * 1.5 * 2.0 = 12.0
	assert_almost_eq(stats.get_value(Stat.DAMAGE), 12.0)
	assert_almost_eq(stats.get_value(Stat.FIRE_RATE), 2.5, 0.0001, "other stats untouched")


func test_limits_clamp_the_result() -> void:
	var stats := PlayerStats.new()
	stats.add_modifier(StatModifier.create(Stat.MOVE_SPEED, 5.0))
	assert_almost_eq(stats.get_value(Stat.MOVE_SPEED), 2.0, 0.0001, "move speed max 2.0")
	stats.add_modifier(StatModifier.create(Stat.MAX_FLAMES, 20.0))
	assert_almost_eq(stats.get_value(Stat.MAX_FLAMES), 12.0, 0.0001, "max 12 flames")
	stats.add_modifier(StatModifier.create(Stat.DAMAGE, -10.0))
	assert_almost_eq(stats.get_value(Stat.DAMAGE), 0.5, 0.0001, "damage floor")


func test_remove_by_source_and_changed_signal() -> void:
	var stats := PlayerStats.new()
	var changes: Array[int] = [0]
	stats.changed.connect(func() -> void: changes[0] += 1)
	stats.add_modifier(StatModifier.create(Stat.FIRE_RATE, 0.5, 1.0, &"fuse"))
	stats.add_modifier(StatModifier.create(Stat.DAMAGE, 0.7, 1.0, &"melting_point"))
	assert_almost_eq(stats.get_value(Stat.FIRE_RATE), 3.0)
	assert_eq(stats.remove_modifiers_from(&"fuse"), 1)
	assert_almost_eq(stats.get_value(Stat.FIRE_RATE), 2.5)
	assert_almost_eq(stats.get_value(Stat.DAMAGE), 3.7)
	assert_eq(changes[0], 3)


func test_player_copies_stats_resource() -> void:
	var shared := load("res://data/player/pit_stats.tres") as PlayerStats
	var player := (load("res://src/player/player.tscn") as PackedScene).instantiate() as Player
	add_child(player)
	player.stats.add_modifier(StatModifier.create(Stat.DAMAGE, 1.0))
	assert_almost_eq(player.stats.get_value(Stat.DAMAGE), 4.0)
	assert_almost_eq(shared.get_value(Stat.DAMAGE), 3.0, 0.0001, "the .tres is not changed")
	assert_almost_eq(player.health.max_health, 6.0, 0.0001, "3 flames = 6 half flames")
