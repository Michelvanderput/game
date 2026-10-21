class_name StatModifier
extends Resource
## One change to one stat. Items will carry these in their Resources.

@export var stat: PlayerStats.Stat = PlayerStats.Stat.DAMAGE
## Added to the base value.
@export var add: float = 0.0
## Multiplies the summed value.
@export var mult: float = 1.0
## Who owns this modifier (usually an item id), so it can be removed again.
@export var source: StringName = &""


static func create(p_stat: PlayerStats.Stat, p_add: float, p_mult: float = 1.0, p_source: StringName = &"") -> StatModifier:
	var modifier := StatModifier.new()
	modifier.stat = p_stat
	modifier.add = p_add
	modifier.mult = p_mult
	modifier.source = p_source
	return modifier
