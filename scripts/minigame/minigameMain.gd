extends Node2D

var turret_scene = preload("res://scenes/minigame/turret.tscn")
const PAUSE_SCENE := preload("res://scenes/pause.tscn")

const ROUND_SECONDS: float = 10.0
const HIT_PENALTY_SECONDS: float = 5.0
const MAX_HITS: int = 3
@export_file("*.tscn") var exploration_scene: String = "res://scenes/exploration.tscn"

var _pause: Node = null
var _hits: int = 0
var _finished: bool = false

func _ready() -> void:
	$Player.position = get_viewport_rect().get_center()
	GameManager.minigameTimer = 0.0
	$Player.hit.connect(_on_player_hit)
	# One turret for each edge: top, right, bottom, left.
	for edge in range(4):
		var turret = turret_scene.instantiate()
		turret.edge = edge
		turret.target = $Player
		turret.fire_rate = 1.2
		turret.timer = edge * 0.3
		add_child(turret)

func _unhandled_input(event: InputEvent) -> void:
	if _finished or not event.is_action_pressed("pause") or event.is_echo():
		return
	if _pause != null and is_instance_valid(_pause):
		return
	_pause = PAUSE_SCENE.instantiate()
	add_child(_pause)
	get_tree().paused = true
	get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if _finished:
		return
	GameManager.minigameTimer = minf(GameManager.minigameTimer + delta, ROUND_SECONDS)
	if GameManager.minigameTimer >= ROUND_SECONDS:
		_finish_round(false)


func _on_player_hit() -> void:
	if _finished:
		return
	_hits += 1
	GameManager.lose_time(HIT_PENALTY_SECONDS)
	if _hits >= MAX_HITS:
		_finish_round(true)


func _finish_round(lost: bool) -> void:
	if _finished:
		return
	_finished = true
	$Player.active = false
	# Stop turrets and collisions immediately; change scenes outside physics callbacks.
	process_mode = Node.PROCESS_MODE_DISABLED
	_leave_round.call_deferred(lost)


func _leave_round(lost: bool) -> void:
	if lost:
		GameManager.end_play()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		# The persistent day timer continues; only the minigame timer resets on entry.
		get_tree().change_scene_to_file(exploration_scene)
