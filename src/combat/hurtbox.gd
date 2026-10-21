class_name Hurtbox
extends Area2D
## Receives hits from Hitboxes and forwards the damage to a Health component.

signal hurt(amount: float, hitbox: Hitbox)

@export var health: Health


## Returns true when the hit did damage (false while invulnerable or dead).
func receive_hit(hitbox: Hitbox) -> bool:
	if health == null or not health.take_damage(hitbox.damage):
		return false
	hurt.emit(hitbox.damage, hitbox)
	return true
