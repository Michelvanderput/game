extends Node
## Global signal hub (autoload "EventBus"). Systems emit and listen here
## instead of holding references to each other.

@warning_ignore_start("unused_signal")
signal run_started(run_seed: int)
signal player_hit(amount: float)
signal player_died
signal enemy_died(enemy: Node)
signal room_cleared(room: Node)
signal item_picked_up(item_id: StringName)
@warning_ignore_restore("unused_signal")
