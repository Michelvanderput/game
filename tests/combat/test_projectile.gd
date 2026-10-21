extends TestCase

const PROJECTILE_SCENE: PackedScene = preload("res://src/combat/projectile.tscn")


func _spawn(speed: float, max_distance: float) -> Projectile:
	var spec := ShotSpec.new()
	spec.origin = Vector2(10000.0, 10000.0)  # far from any physics body
	spec.direction = Vector2.RIGHT
	spec.speed = speed
	spec.max_distance = max_distance
	var projectile := (PROJECTILE_SCENE.instantiate() as Projectile).setup(spec)
	add_child(projectile)
	return projectile


func test_expires_after_range() -> void:
	var projectile := _spawn(120.0, 40.0)  # 2 px per step, 20 steps
	var expired: Array[bool] = [false]
	projectile.expired.connect(func() -> void: expired[0] = true)
	step_physics([projectile], 19)
	assert_false(expired[0], "still flying before its range")
	step_physics([projectile], 1)
	assert_true(expired[0], "expired at its range")
	assert_true(projectile.is_queued_for_deletion())
	assert_almost_eq(projectile.position.x, 10040.0, 0.01)


func test_spec_copy_is_independent() -> void:
	var spec := ShotSpec.new()
	spec.damage = 3.0
	var copy := spec.copy()
	copy.damage = 9.0
	copy.modifiers.append(Resource.new())
	assert_almost_eq(spec.damage, 3.0)
	assert_eq(spec.modifiers.size(), 0)
