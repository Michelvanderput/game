extends TestCase

const RngService: GDScript = preload("res://src/core/rng.gd")


func _sequence(rng: Node, stream_name: StringName, count: int) -> Array[int]:
	var values: Array[int] = []
	for _i: int in count:
		values.append(rng.randi_range(stream_name, 0, 1_000_000))
	return values


func test_same_seed_gives_same_sequence_per_stream() -> void:
	var a: Node = RngService.new()
	var b: Node = RngService.new()
	a.set_seed(1234)
	b.set_seed(1234)
	for stream_name: StringName in RngService.STREAMS:
		assert_eq(_sequence(a, stream_name, 20), _sequence(b, stream_name, 20), "stream %s" % stream_name)
	a.free()
	b.free()


func test_streams_are_independent() -> void:
	var a: Node = RngService.new()
	var b: Node = RngService.new()
	a.set_seed(99)
	b.set_seed(99)
	_sequence(a, &"loot", 50)  # extra loot rolls in run A only
	assert_eq(_sequence(a, &"map", 10), _sequence(b, &"map", 10), "loot rolls must not shift the map stream")
	assert_ne(_sequence(b, &"map", 10), _sequence(b, &"combat", 10), "streams differ from each other")
	a.free()
	b.free()


func test_different_seeds_differ_and_reseeding_restarts() -> void:
	var rng: Node = RngService.new()
	rng.set_seed(1)
	var first := _sequence(rng, &"map", 10)
	rng.set_seed(2)
	assert_ne(_sequence(rng, &"map", 10), first)
	rng.set_seed(1)
	assert_eq(_sequence(rng, &"map", 10), first)
	assert_eq(rng.get_seed(), 1)
	rng.free()


func test_randf_in_unit_range() -> void:
	var rng: Node = RngService.new()
	rng.set_seed(5)
	var all_in_range := true
	for _i: int in 200:
		var value: float = rng.randf(&"combat")
		all_in_range = all_in_range and value >= 0.0 and value <= 1.0
	assert_true(all_in_range)
	rng.free()


func test_pick_and_weighted_pick() -> void:
	var rng: Node = RngService.new()
	rng.set_seed(7)
	assert_eq(rng.pick(&"loot", []), null, "empty pick")
	assert_true(rng.pick(&"loot", ["a", "b", "c"]) in ["a", "b", "c"])
	var weights: Array[float] = [0.0, 1.0, 0.0]
	var only_b := true
	for _i: int in 100:
		only_b = only_b and rng.weighted_pick(&"loot", ["a", "b", "c"], weights) == "b"
	assert_true(only_b, "zero weights are never picked")
	var zeros: Array[float] = [0.0, 0.0]
	assert_eq(rng.weighted_pick(&"loot", ["a", "b"], zeros), null, "all-zero weights")
	rng.free()
