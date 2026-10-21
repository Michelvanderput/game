class_name Hitbox
extends Area2D
## Deals damage to Hurtboxes it touches and reports touching the world.

signal hit_hurtbox(hurtbox: Hurtbox)
signal hit_world(body: Node2D)

@export var damage: float = 1.0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as Hurtbox
	if hurtbox == null:
		return
	hurtbox.receive_hit(self)
	hit_hurtbox.emit(hurtbox)


func _on_body_entered(body: Node2D) -> void:
	hit_world.emit(body)
