extends CharacterBody2D

@export var leader: Node2D
@export var line: Line2D
@export var max_distance: float = 150.0
@export var follow_speed: float = 5.0

func _physics_process(delta: float) -> void:
	if not leader or not line:
		return
		
	# 1. Calculate direction and distance to leader
	var to_leader = leader.global_position - global_position
	var current_distance = to_leader.length()
	
	# 2. Move follower only if it exceeds the max distance
	if current_distance > max_distance:
		var target_position = leader.global_position - (to_leader.normalized() * max_distance)
		global_position = global_position.lerp(target_position, follow_speed * delta)
	
	# 3. Update Line2D points (in local space of the Line2D)
	line.clear_points()
	line.add_point(line.to_local(global_position))
	line.add_point(line.to_local(leader.global_position))
