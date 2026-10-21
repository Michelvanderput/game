class_name Player
extends CharacterBody2D
## Pit: moves in 8 directions, shoots in 4. Placeholder art: orange circle.

signal shot_fired(spec: ShotSpec)

const PROJECTILE_SCENE: PackedScene = preload("res://src/combat/projectile.tscn")

@export var stats: PlayerStats

@export_group("Movement")
## Pixels per second at move speed stat 1.0.
@export var base_move_speed: float = 80.0
## Seconds from standstill to full speed.
@export var acceleration_time: float = 0.08
## Seconds from full speed to standstill.
@export var deceleration_time: float = 0.06

@export_group("Shooting")
## Distance from Pit's centre where shots appear, in pixels.
@export var shot_spawn_offset: float = 5.0
@export var shot_radius: float = 3.0
@export var shot_color: Color = Palette.FLAME

@export_group("Feel")
## Blink interval while invulnerable after a hit, in seconds.
@export var hurt_blink_interval: float = 0.08

## Direction Pit looks at: the shooting direction, otherwise the walking direction.
var facing: Vector2 = Vector2.DOWN
var _cooldown: float = 0.0
var _blink_time: float = 0.0

@onready var health: Health = $Health
@onready var hurtbox: Hurtbox = $Hurtbox


func _ready() -> void:
	# Each Pit gets its own copy, so run-time modifiers never touch the .tres file.
	stats = stats.duplicate() as PlayerStats if stats != null else PlayerStats.new()
	stats.changed.connect(_on_stats_changed)
	health.max_health = stats.get_value(PlayerStats.Stat.MAX_FLAMES) * 2.0
	health.reset()
	hurtbox.hurt.connect(func(amount: float, _hitbox: Hitbox) -> void: EventBus.player_hit.emit(amount))
	health.died.connect(func() -> void: EventBus.player_died.emit())


func _physics_process(delta: float) -> void:
	_move(delta)
	_shoot(delta)
	_update_blink(delta)
	queue_redraw()


func _move(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var max_speed := base_move_speed * stats.get_value(PlayerStats.Stat.MOVE_SPEED)
	var target := input * max_speed
	var ramp_time := acceleration_time if input != Vector2.ZERO else deceleration_time
	var step := max_speed / maxf(ramp_time, 0.001) * delta
	velocity = velocity.move_toward(target, step)
	move_and_slide()
	if input != Vector2.ZERO:
		facing = Player.to_cardinal(input)


func _shoot(delta: float) -> void:
	_cooldown = maxf(0.0, _cooldown - delta)
	var aim := read_shoot_direction()
	if aim == Vector2.ZERO:
		return
	facing = aim
	if _cooldown <= 0.0:
		fire(aim)
		_cooldown += 1.0 / stats.get_value(PlayerStats.Stat.FIRE_RATE)


## The 4-way shooting direction from arrows, face buttons or the right stick.
func read_shoot_direction() -> Vector2:
	var raw := Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	return Player.to_cardinal(raw)


## Builds the ShotSpec for a shot in this direction from the current stats.
func build_shot(direction: Vector2) -> ShotSpec:
	var spec := ShotSpec.new()
	spec.direction = direction.normalized()
	spec.origin = position + spec.direction * shot_spawn_offset
	spec.speed = stats.get_value(PlayerStats.Stat.SHOT_SPEED) * Grid.TILE_SIZE
	spec.max_distance = stats.get_value(PlayerStats.Stat.RANGE) * Grid.TILE_SIZE
	spec.damage = stats.get_value(PlayerStats.Stat.DAMAGE)
	spec.radius = shot_radius
	spec.color = shot_color
	return spec


func fire(direction: Vector2) -> Projectile:
	var spec := build_shot(direction)
	var projectile := (PROJECTILE_SCENE.instantiate() as Projectile).setup(spec)
	get_parent().add_child(projectile)
	shot_fired.emit(spec)
	return projectile


## Snaps a vector to the nearest of the 4 directions (ZERO stays ZERO).
static func to_cardinal(vector: Vector2) -> Vector2:
	if vector.length_squared() < 0.0001:
		return Vector2.ZERO
	if absf(vector.x) >= absf(vector.y):
		return Vector2(signf(vector.x), 0.0)
	return Vector2(0.0, signf(vector.y))


func _on_stats_changed() -> void:
	health.max_health = stats.get_value(PlayerStats.Stat.MAX_FLAMES) * 2.0


func _update_blink(delta: float) -> void:
	if health.is_invulnerable():
		_blink_time += delta
		visible = fmod(_blink_time, hurt_blink_interval * 2.0) < hurt_blink_interval
	else:
		_blink_time = 0.0
		visible = true


func _draw() -> void:
	draw_circle(Vector2.ZERO, 6.0, Palette.INK)
	draw_circle(Vector2.ZERO, 5.0, Palette.FLAME)
	draw_circle(Vector2(0.0, 1.0), 3.0, Palette.GOLD)
	# Eyes look where Pit faces.
	var look := facing * 2.0
	var side := Vector2(-facing.y, facing.x).abs()
	for sign_value: float in [-1.0, 1.0]:
		var eye := (look + side * 2.0 * sign_value).round()
		draw_rect(Rect2(eye - Vector2(0.5, 0.5), Vector2(1.0, 2.0)), Palette.INK)
