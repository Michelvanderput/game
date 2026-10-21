class_name Projectile
extends Node2D
## A shot in flight. All behaviour comes from its ShotSpec; new shot effects belong
## in shot modifiers (task 002), never as special cases here.

signal expired

var spec: ShotSpec = ShotSpec.new()
var travelled: float = 0.0
var _done: bool = false

@onready var hitbox: Hitbox = $Hitbox
@onready var _shape: CollisionShape2D = $Hitbox/CollisionShape2D


func setup(shot: ShotSpec) -> Projectile:
	spec = shot
	position = shot.origin
	return self


func _ready() -> void:
	hitbox.damage = spec.damage
	var circle := CircleShape2D.new()
	circle.radius = spec.radius
	_shape.shape = circle
	hitbox.hit_hurtbox.connect(func(_hurtbox: Hurtbox) -> void: despawn())
	hitbox.hit_world.connect(func(_body: Node2D) -> void: despawn())


func _physics_process(delta: float) -> void:
	if _done:
		return
	var step := spec.speed * delta
	position += spec.direction * step
	travelled += step
	if travelled >= spec.max_distance:
		despawn()


func despawn() -> void:
	if _done:
		return
	_done = true
	hitbox.set_deferred("monitoring", false)
	expired.emit()
	if get_parent() != null:
		Poof.spawn(get_parent(), position, spec.color)
	queue_free()


func _draw() -> void:
	draw_circle(Vector2.ZERO, spec.radius, spec.color)
	draw_circle(Vector2(-0.5, -0.5), maxf(1.0, spec.radius - 2.0), Palette.CREAM)
