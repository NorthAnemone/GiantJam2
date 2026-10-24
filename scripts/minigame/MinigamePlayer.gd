extends Area2D

signal hit

const speed = 200
var active: bool = true
var invulnerability_time = 0.0

func _process(delta: float) -> void:
	if not active:
		return
	invulnerability_time = maxf(0.0, invulnerability_time - delta)
	modulate = Color(1, 0.3, 0.3) if invulnerability_time > 0.0 else Color.WHITE
	var movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += movement * speed * delta
	var bounds = get_viewport_rect().grow(-16.0)
	position = position.clamp(bounds.position, bounds.end)

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("bullets") or not active:
		return
	area.queue_free()
	if invulnerability_time > 0.0:
		return
	invulnerability_time = 0.5
	hit.emit()
