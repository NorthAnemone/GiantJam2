extends Node2D
var turret_scene = preload("res://turret.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turret = turret_scene.instantiate()
	add_child(turret)
	turret.position = Vector2(100,100)
	turret.fire_rate = 1
	turret.bullets_to_fire * 10

	turret = turret_scene.instantiate()
	add_child(turret)
	turret.position = Vector2(200,200)
	turret.fire_rate = 0.8
	turret.bullets_to_fire * 5

	turret = turret_scene.instantiate()
	add_child(turret)
	turret.position = Vector2(150,150)
	turret.fire_rate = 5
	turret.bullets_to_fire * 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
