extends Node
## Seeded randomness (autoload "Rng"). Never call randi()/randf() directly:
## draw from a named stream so a run with the same seed plays out identically.
## Each stream gets its own generator, so e.g. extra loot rolls never change the map.

const STREAMS: Array[StringName] = [&"map", &"loot", &"combat"]

var run_seed: int = 0
var _streams: Dictionary[StringName, RandomNumberGenerator] = {}


func _init() -> void:
	set_seed(0)


func set_seed(new_seed: int) -> void:
	run_seed = new_seed
	_streams.clear()
	for stream_name: StringName in STREAMS:
		var generator := RandomNumberGenerator.new()
		generator.seed = ("%d:%s" % [new_seed, stream_name]).hash()
		_streams[stream_name] = generator


func get_seed() -> int:
	return run_seed


func stream(stream_name: StringName) -> RandomNumberGenerator:
	assert(_streams.has(stream_name), "Unknown RNG stream: %s" % stream_name)
	return _streams[stream_name]


## Random int in [from, to], both inclusive.
func randi_range(stream_name: StringName, from: int, to: int) -> int:
	return stream(stream_name).randi_range(from, to)


## Random float in [0, 1].
func randf(stream_name: StringName) -> float:
	return stream(stream_name).randf()


## Random float in [from, to].
func randf_range(stream_name: StringName, from: float, to: float) -> float:
	return stream(stream_name).randf_range(from, to)


## Uniformly picks one element; returns null for an empty array.
func pick(stream_name: StringName, items: Array) -> Variant:
	if items.is_empty():
		return null
	return items[stream(stream_name).randi_range(0, items.size() - 1)]


## Picks one element with probability proportional to its weight.
## Returns null when the arrays are empty, differ in size, or all weights are zero.
func weighted_pick(stream_name: StringName, items: Array, weights: Array[float]) -> Variant:
	if items.is_empty() or items.size() != weights.size():
		return null
	var index := stream(stream_name).rand_weighted(PackedFloat32Array(weights))
	if index < 0:
		return null
	return items[index]
