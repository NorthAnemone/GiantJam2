extends Area2D
var bullet_scene = preload("res://bullet.tscn")
var timer = 0
var angle = 0
var fire_rate = 0.2
var bullets_to_fire = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > fire_rate:
		for counter in range (bullets_to_fire):
			angle += 2 * PI / bullets_to_fire
			var bullet = bullet_scene.instantiate()
			bullet.direction = Vector2(cos(angle), sin(angle))
			get_parent().add_child(bullet)
			bullet.global_position = global_position
			timer = 0
