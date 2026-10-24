class_name Menu
extends Node2D

## Scene the Play button opens. Assign this in the inspector.
@export var play_scene: PackedScene

@onready var playButton: Button = $UILayer/UI/Buttons/PlayButton
@onready var optionsButton: Button = $UILayer/UI/Buttons/OptionsButton
@onready var creditsButton: Button = $UILayer/UI/Buttons/CreditsButton
@onready var closeButton: Button = $UILayer/UI/Buttons/CloseButton
@onready var creditsPanel: ColorRect = $UILayer/UI/CreditsPanel
@onready var creditsText: Label = $UILayer/UI/CreditsClip/CreditsText
@onready var titleLogo: Sprite2D = $TitleLogo
@onready var backdrop: Sprite2D = $Backdrop
@onready var backdrop2: Sprite2D = $Backdrop2
@onready var buttons_root: Control = $UILayer/UI/Buttons
@onready var ui_layer: CanvasLayer = $UILayer
@onready var options: CanvasItem = $Options

@export var creditsScrollSpeed: float = 30.0
var creditsActive: bool = false
@export var menuBgScrollSpeed: float = 20.0
var _leaving: bool = false
var _bg_y: float = 0.0

const DESIGN_SIZE := Vector2(640, 360)

static var padding: float = 10.0

var _buttons: Array[Button] = []


func _ready() -> void:
	_buttons = [playButton, optionsButton, creditsButton, closeButton]
	_apply_text()
	_fit_buttons()
	get_viewport().size_changed.connect(_fit_buttons)
	_place_backdrop()


static func fit_control(node: Control) -> void:
	if node == null:
		return
	var view := node.get_viewport().get_visible_rect().size
	if view.x <= 0.0 or view.y <= 0.0:
		return
	node.scale = view / DESIGN_SIZE


func _fit_buttons() -> void:
	fit_control(buttons_root)


func _apply_text() -> void:
	var text := UiText.section("menu")
	var body = text.get("credits_body", [])
	var credits := ""
	if body is Array:
		credits = "\n".join(body)
	elif body is String:
		credits = body
	_set_label(creditsText, credits)


func _set_label(node: Node, value: String) -> void:
	if node != null:
		node.set("text", value)


func _process(elapsed: float) -> void:
	if backdrop.texture:
		var tile_h: float = backdrop.texture.get_height() * backdrop.scale.y
		if tile_h > 0.0:
			_bg_y = fmod(_bg_y + menuBgScrollSpeed * elapsed, tile_h)
			_place_backdrop()

	if creditsActive:
		creditsText.position.y -= creditsScrollSpeed * elapsed
		if creditsText.position.y + creditsText.size.y < 0:
			creditsText.position.y = creditsPanel.size.y

	if _leaving:
		var dx: float = 450.0 * elapsed
		titleLogo.position.x -= dx
		if buttons_root != null:
			buttons_root.position.x -= dx
		var logo_w: float = 0.0
		if titleLogo.texture:
			logo_w = titleLogo.texture.get_width() * titleLogo.scale.x
		var logo_right: float = titleLogo.position.x + logo_w
		var buttons_right := 0.0
		if buttons_root != null:
			buttons_right = buttons_root.position.x + 135.0 * buttons_root.scale.x
		if buttons_right < 0.0 and logo_right < 0.0:
			_leaving = false
			get_tree().change_scene_to_packed(play_scene)


func _place_backdrop() -> void:
	if backdrop.texture == null:
		return
	backdrop.position.y = _bg_y
	backdrop2.position.y = _bg_y - backdrop.texture.get_height() * backdrop.scale.y


func closeGame() -> void:
	get_tree().quit()


func clickPlay() -> void:
	if _leaving:
		return
	if play_scene == null:
		push_warning("Assign play_scene on the menu to the scene Play should open.")
		return
	_leaving = true
	for b in _buttons:
		b.disabled = true


func optionsMenu() -> void:
	if _leaving:
		return
	_show_menu(false)
	if ui_layer != null:
		ui_layer.visible = false
	options.show()


func show_main_menu() -> void:
	options.hide()
	if ui_layer != null:
		ui_layer.visible = true
	_show_menu(true)


func _show_menu(show_menu: bool) -> void:
	titleLogo.visible = show_menu
	for b in _buttons:
		if b == null:
			continue
		b.visible = show_menu
		b.disabled = not show_menu
	if not show_menu:
		if creditsText != null:
			creditsText.visible = false
		if creditsPanel != null:
			creditsPanel.visible = false
		creditsActive = false


func showCredits() -> void:
	creditsText.visible = not creditsText.visible
	creditsPanel.visible = creditsText.visible
	if creditsText.visible:
		creditsText.position.y = creditsPanel.size.y
		creditsActive = true
	else:
		creditsActive = false
