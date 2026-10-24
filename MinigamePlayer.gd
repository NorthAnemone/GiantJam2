extends Area2D
const speed = 200
var health = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("LETS GOOO!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
	
	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta
		
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
		
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		health -= 1
		if health == 0:
			get_tree().paused=true
		area.queue_free()
	
		modulate = Color(1, 0.3, 0.3)
		await get_tree().create_timer(0.2).timeout
		modulate = Color(1,1,1)
