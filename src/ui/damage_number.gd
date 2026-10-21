class_name DamageNumber
extends Label
## Small number that floats up and fades out.

@export var rise_distance: float = 10.0
@export var duration: float = 0.5


static func spawn(parent: Node, at: Vector2, amount: float) -> DamageNumber:
	var number := DamageNumber.new()
	number.text = DamageNumber.format_amount(amount)
	parent.add_child(number)
	number.position = at - number.size * 0.5
	return number


static func format_amount(amount: float) -> String:
	if is_equal_approx(amount, roundf(amount)):
		return "%d" % int(roundf(amount))
	return "%.1f" % amount


func _ready() -> void:
	var settings := LabelSettings.new()
	settings.font_size = 8
	settings.font_color = Palette.WHITE
	settings.outline_size = 2
	settings.outline_color = Palette.INK
	label_settings = settings
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	z_index = 10
	reset_size()
	var tween := create_tween().set_parallel()
	tween.tween_property(self, "position:y", position.y - rise_distance, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_delay(duration * 0.5)
	tween.chain().tween_callback(queue_free)
