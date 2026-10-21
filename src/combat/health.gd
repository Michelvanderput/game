class_name Health
extends Node
## Hit points plus optional invulnerability after a hit.
## For Pit one point is half a flame; for enemies it is plain HP.

signal damaged(amount: float)
signal healed(amount: float)
signal changed(current: float, maximum: float)
signal died

@export var max_health: float = 6.0
## Seconds without damage after taking a hit. 0 = none.
@export var invulnerability_time: float = 0.0

var current: float = 0.0
var is_dead: bool = false
var _invulnerable_left: float = 0.0


func _ready() -> void:
	reset()


func _physics_process(delta: float) -> void:
	if _invulnerable_left > 0.0:
		_invulnerable_left = maxf(0.0, _invulnerable_left - delta)


## Back to full health and alive.
func reset() -> void:
	current = max_health
	is_dead = false
	_invulnerable_left = 0.0
	changed.emit(current, max_health)


## Returns true when the damage was applied.
func take_damage(amount: float) -> bool:
	if is_dead or amount <= 0.0 or is_invulnerable():
		return false
	current = maxf(0.0, current - amount)
	_invulnerable_left = invulnerability_time
	damaged.emit(amount)
	changed.emit(current, max_health)
	if current <= 0.0:
		is_dead = true
		died.emit()
	return true


func heal(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	var before := current
	current = minf(max_health, current + amount)
	if current > before:
		healed.emit(current - before)
		changed.emit(current, max_health)


func is_invulnerable() -> bool:
	return _invulnerable_left > 0.0
