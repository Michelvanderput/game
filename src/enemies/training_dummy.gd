class_name TrainingDummy
extends StaticBody2D
## Practice target: takes damage, flashes white, shows the number, and stands up
## again with full health a moment after it "dies".

@export var flash_time: float = 0.08
@export var respawn_delay: float = 1.0
## Horizontal squash on hit (1.0 = none).
@export var hit_squash: float = 1.25

var _flash_left: float = 0.0

@onready var health: Health = $Health
@onready var hurtbox: Hurtbox = $Hurtbox


func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)
	health.died.connect(_on_died)


func _process(delta: float) -> void:
	if _flash_left > 0.0:
		_flash_left = maxf(0.0, _flash_left - delta)
		queue_redraw()


func _on_hurt(amount: float, _hitbox: Hitbox) -> void:
	_flash_left = flash_time
	queue_redraw()
	DamageNumber.spawn(get_parent(), position + Vector2(0.0, -12.0), amount)
	scale = Vector2(hit_squash, 1.0 / hit_squash)
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_died() -> void:
	Poof.spawn(get_parent(), position, Palette.CREAM)
	modulate.a = 0.3
	await get_tree().create_timer(respawn_delay).timeout
	modulate.a = 1.0
	health.reset()


func _draw() -> void:
	var flashing := _flash_left > 0.0
	var body := Palette.WHITE if flashing else Palette.BARK
	var face := Palette.WHITE if flashing else Palette.CREAM
	draw_rect(Rect2(-6.0, -7.0, 12.0, 14.0), Palette.INK)
	draw_rect(Rect2(-5.0, -6.0, 10.0, 12.0), body)
	draw_rect(Rect2(-3.0, -4.0, 6.0, 5.0), face)
	draw_rect(Rect2(-2.0, -3.0, 1.0, 1.0), Palette.INK)
	draw_rect(Rect2(1.0, -3.0, 1.0, 1.0), Palette.INK)
