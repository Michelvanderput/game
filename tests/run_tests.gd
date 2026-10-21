extends SceneTree
## Minimal headless test runner, GUT-style (GUT can replace it later).
## Runs every tests/**/test_*.gd whose script extends TestCase.
##   godot --headless --import            (once, or after adding classes)
##   godot --headless -s res://tests/run_tests.gd
## Optional filter: append  -- test_rng  to run only files containing that text.

const TEST_ROOT: String = "res://tests"


## Collects engine and script errors so a crashing test fails instead of passing quietly.
class ErrorCollector extends Logger:
	var errors: PackedStringArray = []
	var _mutex := Mutex.new()

	func _log_error(function: String, file: String, line: int, code: String, rationale: String, _editor_notify: bool, error_type: int, _script_backtraces: Array[ScriptBacktrace]) -> void:
		_mutex.lock()
		var kind := "warning" if error_type == ERROR_TYPE_WARNING else "error"
		errors.append("%s: %s (%s:%d %s)" % [kind, rationale if rationale != "" else code, file, line, function])
		_mutex.unlock()

	func take() -> PackedStringArray:
		_mutex.lock()
		var taken := errors.duplicate()
		errors.clear()
		_mutex.unlock()
		return taken


func _initialize() -> void:
	_run()


func _run() -> void:
	# Let autoloads finish _ready before tests start.
	await process_frame
	var filter := ""
	var user_args := OS.get_cmdline_user_args()
	if not user_args.is_empty():
		filter = user_args[0]
	var collector := ErrorCollector.new()
	OS.add_logger(collector)
	var files := _find_tests(TEST_ROOT)
	var passed := 0
	var failed_tests := 0
	var failed: PackedStringArray = []
	for path: String in files:
		if filter != "" and not path.contains(filter):
			continue
		var script := load(path) as GDScript
		if script == null:
			failed_tests += 1
			failed.append("%s: could not load" % path)
			continue
		for method: Dictionary in script.get_script_method_list():
			var name: String = method["name"]
			if not name.begins_with("test_"):
				continue
			var test := script.new() as TestCase
			if test == null:
				failed_tests += 1
				failed.append("%s: does not extend TestCase" % path)
				break
			root.add_child(test)
			collector.take()
			test.before_each()
			await test.call(name)
			test.after_each()
			var label := "%s::%s" % [path.get_file().get_basename(), name]
			test.failures.append_array(collector.take())
			if test.assertion_count == 0:
				test.failures.append("no assertions ran (script error?)")
			if test.failures.is_empty():
				passed += 1
				print("  ok    %s" % label)
			else:
				failed_tests += 1
				for failure: String in test.failures:
					failed.append("%s: %s" % [label, failure])
				print("  FAIL  %s" % label)
			test.queue_free()
			await process_frame
	print("")
	for failure: String in failed:
		printerr("FAIL %s" % failure)
	print("%d passed, %d failed" % [passed, failed_tests])
	quit(0 if failed.is_empty() else 1)


func _find_tests(dir_path: String) -> PackedStringArray:
	var found: PackedStringArray = []
	for sub: String in DirAccess.get_directories_at(dir_path):
		found.append_array(_find_tests(dir_path.path_join(sub)))
	for file: String in DirAccess.get_files_at(dir_path):
		if file.begins_with("test_") and file.ends_with(".gd"):
			found.append(dir_path.path_join(file))
	found.sort()
	return found
