extends CharacterBody2D

@export var leader: Node2D
@export var line: Line2D
@export var max_distance: float = 150.0

func _physics_process(_delta: float) -> void:
	if not leader or not line:
		return
		
	# 1. Calculate vector and distance to the leader
	var to_leader = leader.global_position - global_position
	var current_distance = to_leader.length()
	
	# 2. If past the limit, instantly snap to the leash boundary (stop dead inside it)
	if current_distance > max_distance:
		global_position = leader.global_position - (to_leader.normalized() * max_distance)
	
	# 3. Update Line2D points
	line.clear_points()
	line.add_point(line.to_local(global_position))
	line.add_point(line.to_local(leader.global_position))
