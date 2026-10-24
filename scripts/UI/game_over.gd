extends Control


func _ready() -> void:
	get_tree().paused = false
	$Center/Buttons/Retry.pressed.connect(_retry)
	$Center/Buttons/Menu.pressed.connect(_menu)
	$Center/Buttons/Retry.grab_focus()


func _retry() -> void:
	GameManager.begin_play()
	get_tree().change_scene_to_file("res://scenes/minigame/minigameMain.tscn")


func _menu() -> void:
	GameManager.end_play()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
