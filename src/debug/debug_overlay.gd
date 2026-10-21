class_name DebugOverlay
extends CanvasLayer
## F1: seed, FPS and Pit's stats. R (restart) is handled by GameState.

@export var refresh_interval: float = 0.25
@export var start_visible: bool = false

var _label: Label
var _refresh_left: float = 0.0


func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	_label = Label.new()
	_label.position = Vector2(4.0, 4.0)
	var settings := LabelSettings.new()
	settings.font_size = 8
	settings.line_spacing = -2.0
	settings.font_color = Palette.CREAM
	settings.outline_size = 2
	settings.outline_color = Palette.INK
	_label.label_settings = settings
	add_child(_label)
	visible = start_visible
	_refresh()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_toggle"):
		visible = not visible
		_refresh()
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if not visible:
		return
	_refresh_left -= delta
	if _refresh_left <= 0.0:
		_refresh_left = refresh_interval
		_refresh()


func _refresh() -> void:
	var lines: PackedStringArray = [
		"SEED %d" % GameState.run_seed,
		"FPS %d" % Engine.get_frames_per_second(),
	]
	var player := get_tree().get_first_node_in_group("player") as Player
	if player != null and player.stats != null:
		var s := player.stats
		lines.append("HP %s/%s" % [player.health.current / 2.0, player.health.max_health / 2.0])
		lines.append("DMG %.2f  RATE %.2f/s" % [s.get_value(PlayerStats.Stat.DAMAGE), s.get_value(PlayerStats.Stat.FIRE_RATE)])
		lines.append("RANGE %.2f  SHOT %.2f" % [s.get_value(PlayerStats.Stat.RANGE), s.get_value(PlayerStats.Stat.SHOT_SPEED)])
		lines.append("SPEED %.2f  LUCK %.2f" % [s.get_value(PlayerStats.Stat.MOVE_SPEED), s.get_value(PlayerStats.Stat.LUCK)])
		lines.append("GLOW %.2f" % s.get_value(PlayerStats.Stat.GLOW))
	_label.text = "\n".join(lines)
