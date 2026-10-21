class_name Poof
extends CPUParticles2D
## Small one-shot burst, e.g. when a projectile fades out. Frees itself.

@export var particle_count: int = 6
@export var particle_lifetime: float = 0.25
@export var burst_speed: float = 30.0


static func spawn(parent: Node, at: Vector2, tint: Color) -> Poof:
	var poof := Poof.new()
	poof.color = tint
	poof.position = at
	parent.add_child(poof)
	return poof


func _ready() -> void:
	amount = particle_count
	lifetime = particle_lifetime
	one_shot = true
	explosiveness = 1.0
	direction = Vector2.UP
	spread = 180.0
	gravity = Vector2.ZERO
	initial_velocity_min = burst_speed * 0.5
	initial_velocity_max = burst_speed
	damping_min = burst_speed * 2.0
	damping_max = burst_speed * 3.0
	scale_amount_min = 1.0
	scale_amount_max = 2.0
	finished.connect(queue_free)
	emitting = true
