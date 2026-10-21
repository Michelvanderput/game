extends TestCase
## Smoke test: the real room scene runs with physics and Pit's shots hit the dummy.


func after_each() -> void:
	Input.action_release(&"shoot_right")


func test_room_builds_walls_and_doors() -> void:
	var room := (load("res://src/rooms/test_room.tscn") as PackedScene).instantiate() as TestRoom
	add_child(room)
	assert_eq(room.tiles.get_used_cells().size(), Grid.ROOM_TILES.x * Grid.ROOM_TILES.y)
	assert_eq(room.tiles.get_cell_atlas_coords(Vector2i(0, 0)), Vector2i(TestRoom.Tile.WALL, 0))
	assert_eq(room.tiles.get_cell_atlas_coords(Vector2i(3, 2)), Vector2i(TestRoom.Tile.ROCK, 0))
	var doors := room.get_children().filter(func(n: Node) -> bool: return n.name.begins_with("Door"))
	assert_eq(doors.size(), 4)


func test_shots_hit_the_dummy() -> void:
	var room := (load("res://src/rooms/test_room.tscn") as PackedScene).instantiate() as TestRoom
	add_child(room)
	var dummy := room.get_node("TrainingDummy") as TrainingDummy
	Input.action_press(&"shoot_right")
	for _i: int in 60:
		await get_tree().physics_frame
	Input.action_release(&"shoot_right")
	assert_true(dummy.health.current < dummy.health.max_health, "dummy took damage (hp %s)" % dummy.health.current)
	assert_almost_eq(fmod(dummy.health.max_health - dummy.health.current, 3.0), 0.0, 0.001, "in steps of Pit's damage")


func test_shots_stop_at_walls() -> void:
	var room := (load("res://src/rooms/test_room.tscn") as PackedScene).instantiate() as TestRoom
	add_child(room)
	var player := room.get_node("Player") as Player
	player.stats.add_modifier(StatModifier.create(PlayerStats.Stat.RANGE, 30.0))
	var projectile := player.fire(Vector2.UP)
	var travelled: Array[float] = [-1.0]
	projectile.expired.connect(func() -> void: travelled[0] = projectile.travelled)
	for _i: int in 60:
		await get_tree().physics_frame
	assert_true(travelled[0] >= 0.0, "shot gone")
	assert_true(travelled[0] < 6.0 * Grid.TILE_SIZE, "stopped by the wall, not by range (travelled %s)" % travelled[0])
