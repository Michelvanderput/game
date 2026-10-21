extends Node
## Run-level state (autoload "GameState"): current seed and run status.

enum RunState { NONE, PLAYING, DEAD, WON }

var run_seed: int = 0
var run_state: RunState = RunState.NONE


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if run_state == RunState.NONE:
		start_run()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restart_with_new_seed()
		get_viewport().set_input_as_handled()


## Starts a run. A negative seed picks a fresh one.
func start_run(seed_value: int = -1) -> void:
	run_seed = seed_value if seed_value >= 0 else make_seed()
	Rng.set_seed(run_seed)
	run_state = RunState.PLAYING
	EventBus.run_started.emit(run_seed)


func restart_with_new_seed() -> void:
	start_run()
	get_tree().reload_current_scene()


## The only place where a seed comes from outside the RNG service.
static func make_seed() -> int:
	return (Time.get_ticks_usec() ^ int(Time.get_unix_time_from_system() * 1000.0)) & 0x7FFFFFFF
