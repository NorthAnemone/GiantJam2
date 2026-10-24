extends CharacterBody2D

var value: float = 1.0
var skillScalar: float = 1.0 # defines enemy difficulty/level
var damage: float = 1.0
var enemyName: String = "enemy"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("lure") && !GameManager.isMinigame:
		GameManager.isMinigame = !GameManager.isMinigame
		load_sub_scene("res://scenes/minigame/minigameMain.tscn")
		pass 
		
#func load_overlay_scene():
	## 1. Load the scene file from your resources
	#var overlay_scene = load("res://scenes/minigame/minigameMain.tscn")
	#
	## 2. Instantiate the scene to create a concrete instance of it
	#var overlay_instance = overlay_scene.instantiate()
	#
	## 3. Add it as a child to the current scene so it displays on top
	#add_child(overlay_instance)
	#
func load_sub_scene(scene_path: String) -> void:
	# 1. Pause the main game tree
	#get_tree().paused = true
	
	# 2. Load and instantiate the new scene
	var new_scene_packed: PackedScene = load(scene_path)
	var new_scene_instance: Node = new_scene_packed.instantiate()
	new_scene_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# 3. Add it to the tree root so it sits on top of everything
	get_tree().root.add_child(new_scene_instance)
