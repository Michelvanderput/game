class_name ShotSpec
extends RefCounted
## Everything one shot needs. The shooter builds it from its stats; from task 002
## the modifier pipeline (docs/gdd.md 5.3) transforms it before a Projectile is spawned.

var origin: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
## Pixels per second.
var speed: float = 112.0
## Pixels travelled before the shot fades out.
var max_distance: float = 104.0
var damage: float = 3.0
## Collision and draw radius in pixels.
var radius: float = 3.0
var color: Color = Palette.FLAME
## ShotModifier resources, applied in a fixed order by the pipeline (task 002).
var modifiers: Array[Resource] = []


func copy() -> ShotSpec:
	var spec := ShotSpec.new()
	spec.origin = origin
	spec.direction = direction
	spec.speed = speed
	spec.max_distance = max_distance
	spec.damage = damage
	spec.radius = radius
	spec.color = color
	spec.modifiers = modifiers.duplicate()
	return spec
