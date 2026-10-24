class_name Pause
extends CanvasLayer

static var isPaused: bool = false

var _armed: bool = false


func _ready() -> void:
	isPaused = true
	Menu.fit_control($UI)
	get_viewport().size_changed.connect(func() -> void:
		Menu.fit_control($UI)
	)
	var text := UiText.section("pause")
	_set_label($UI/PauseText, text.get("title", ""))
	_set_label($UI/ContinueButton, text.get("continue", ""))
	_set_label($UI/RestartButton, text.get("restart", ""))
	_set_label($UI/ExitButton, text.get("exit", ""))


func _set_label(node: Node, value: String) -> void:
	if node != null:
		node.set("text", value)


func _exit_tree() -> void:
	isPaused = false


func _process(_elapsed: float) -> void:
	if not _armed:
		_armed = true
		return
	if Input.is_action_just_pressed("pause"):
		onContinue()


func onContinue() -> void:
	isPaused = not isPaused
	queue_free()


func onRestart() -> void:
	isPaused = false
	get_tree().reload_current_scene()


func onExit() -> void:
	isPaused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
