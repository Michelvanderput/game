class_name PlayerStats
extends Resource
## Pit's stats. Final value = (base + sum of adds) * product of mults, then clamped
## to the stat's limits. Start values from docs/gdd.md section 4.

enum Stat { MAX_FLAMES, DAMAGE, FIRE_RATE, RANGE, SHOT_SPEED, MOVE_SPEED, LUCK, GLOW }

## Min and max per stat (inclusive).
const LIMITS: Dictionary[Stat, Vector2] = {
	Stat.MAX_FLAMES: Vector2(0.5, 12.0),
	Stat.DAMAGE: Vector2(0.5, INF),
	Stat.FIRE_RATE: Vector2(0.5, 30.0),
	Stat.RANGE: Vector2(1.0, INF),
	Stat.SHOT_SPEED: Vector2(2.0, INF),
	Stat.MOVE_SPEED: Vector2(0.5, 2.0),
	Stat.LUCK: Vector2(-INF, INF),
	Stat.GLOW: Vector2(0.0, INF),
}

## Flames (lives); 1 flame = 2 half flames of health.
@export var base_max_flames: float = 3.0
@export var base_damage: float = 3.0
## Shots per second.
@export var base_fire_rate: float = 2.5
## In tiles.
@export var base_range: float = 6.5
## In tiles per second.
@export var base_shot_speed: float = 7.0
## Multiplier on the player's base movement speed.
@export var base_move_speed: float = 1.0
@export var base_luck: float = 0.0
## Light radius in tiles.
@export var base_glow: float = 3.5

var _modifiers: Array[StatModifier] = []


func get_base(stat: Stat) -> float:
	match stat:
		Stat.MAX_FLAMES: return base_max_flames
		Stat.DAMAGE: return base_damage
		Stat.FIRE_RATE: return base_fire_rate
		Stat.RANGE: return base_range
		Stat.SHOT_SPEED: return base_shot_speed
		Stat.MOVE_SPEED: return base_move_speed
		Stat.LUCK: return base_luck
		Stat.GLOW: return base_glow
	return 0.0


func get_value(stat: Stat) -> float:
	var total_add := 0.0
	var total_mult := 1.0
	for modifier: StatModifier in _modifiers:
		if modifier.stat == stat:
			total_add += modifier.add
			total_mult *= modifier.mult
	var limits: Vector2 = LIMITS[stat]
	return clampf((get_base(stat) + total_add) * total_mult, limits.x, limits.y)


func add_modifier(modifier: StatModifier) -> void:
	_modifiers.append(modifier)
	emit_changed()


func remove_modifier(modifier: StatModifier) -> void:
	_modifiers.erase(modifier)
	emit_changed()


## Removes every modifier with this source; returns how many were removed.
func remove_modifiers_from(source: StringName) -> int:
	var before := _modifiers.size()
	_modifiers = _modifiers.filter(func(m: StatModifier) -> bool: return m.source != source)
	var removed := before - _modifiers.size()
	if removed > 0:
		emit_changed()
	return removed


func get_modifiers() -> Array[StatModifier]:
	return _modifiers.duplicate()
