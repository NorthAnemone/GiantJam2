extends Area2D

var speed = 400
var direction = Vector2(-1,1)
var screen_rect

func _ready():
	screen_rect = get_viewport().get_visible_rect()
func _process(delta: float) -> void:
	position += direction * speed * delta
	if not screen_rect.has_point(global_position):
		queue_free()
