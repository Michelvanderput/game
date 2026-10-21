class_name TestCase
extends Node
## Base class for tests (GUT-style, see tests/run_tests.gd). Every method that
## starts with "test_" runs on a fresh instance; it may await frames.

var failures: PackedStringArray = []
var assertion_count: int = 0


func before_each() -> void:
	pass


func after_each() -> void:
	pass


func assert_true(condition: bool, message: String = "") -> void:
	assertion_count += 1
	if not condition:
		failures.append("expected true. %s" % message)


func assert_false(condition: bool, message: String = "") -> void:
	assertion_count += 1
	if condition:
		failures.append("expected false. %s" % message)


func assert_eq(actual: Variant, expected: Variant, message: String = "") -> void:
	assertion_count += 1
	if typeof(actual) != typeof(expected) or actual != expected:
		failures.append("expected %s, got %s. %s" % [var_to_str(expected), var_to_str(actual), message])


func assert_ne(actual: Variant, unexpected: Variant, message: String = "") -> void:
	assertion_count += 1
	if typeof(actual) == typeof(unexpected) and actual == unexpected:
		failures.append("did not expect %s. %s" % [var_to_str(unexpected), message])


func assert_almost_eq(actual: float, expected: float, tolerance: float = 0.0001, message: String = "") -> void:
	assertion_count += 1
	if absf(actual - expected) > tolerance:
		failures.append("expected %s (+/- %s), got %s. %s" % [expected, tolerance, actual, message])


## Steps the given nodes' physics manually, n times with a fixed delta.
func step_physics(nodes: Array[Node], steps: int, delta: float = 1.0 / 60.0) -> void:
	for _i: int in steps:
		for node: Node in nodes:
			if is_instance_valid(node) and not node.is_queued_for_deletion():
				node._physics_process(delta)
