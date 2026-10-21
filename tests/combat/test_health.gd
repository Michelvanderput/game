extends TestCase


func _make_health(max_health: float, invulnerability: float) -> Health:
	var health := Health.new()
	health.max_health = max_health
	health.invulnerability_time = invulnerability
	add_child(health)
	return health


func test_damage_reduces_health() -> void:
	var health := _make_health(20.0, 0.0)
	assert_true(health.take_damage(3.0))
	assert_almost_eq(health.current, 17.0)
	assert_false(health.take_damage(0.0), "zero damage is ignored")


func test_invulnerability_blocks_until_time_passed() -> void:
	var health := _make_health(6.0, 1.0)
	assert_true(health.take_damage(1.0))
	assert_true(health.is_invulnerable())
	assert_false(health.take_damage(1.0), "blocked while invulnerable")
	step_physics([health], 30)  # 0.5 s
	assert_false(health.take_damage(1.0), "still blocked at 0.5 s")
	step_physics([health], 31)  # > 1.0 s in total
	assert_false(health.is_invulnerable())
	assert_true(health.take_damage(1.0))
	assert_almost_eq(health.current, 4.0)


func test_died_emitted_once() -> void:
	var health := _make_health(2.0, 0.0)
	var deaths: Array[int] = [0]
	health.died.connect(func() -> void: deaths[0] += 1)
	health.take_damage(5.0)
	assert_true(health.is_dead)
	assert_almost_eq(health.current, 0.0, 0.0001, "never below zero")
	assert_false(health.take_damage(1.0), "no damage after death")
	assert_eq(deaths[0], 1)


func test_heal_clamps_and_reset_revives() -> void:
	var health := _make_health(6.0, 0.0)
	health.take_damage(3.0)
	health.heal(10.0)
	assert_almost_eq(health.current, 6.0)
	health.take_damage(6.0)
	health.reset()
	assert_false(health.is_dead)
	assert_almost_eq(health.current, 6.0)


func test_hurtbox_forwards_hitbox_damage() -> void:
	var health := _make_health(20.0, 0.0)
	var hurtbox := Hurtbox.new()
	hurtbox.health = health
	add_child(hurtbox)
	var hitbox := Hitbox.new()
	hitbox.damage = 3.0
	assert_true(hurtbox.receive_hit(hitbox))
	assert_almost_eq(health.current, 17.0)
	hitbox.free()
