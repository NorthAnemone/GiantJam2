class_name Options
extends Node2D

@onready var shipButton: Button = $Panel/ShipButton
@onready var musicSlider: HSlider = $Panel/MusicSlider
@onready var sfxSlider: HSlider = $Panel/SfxSlider

const SAVE_PATH: String = "user://Pira2ite.cfg"

var currentShipNumber: int = 0

@export var ship_textures: Array[Texture2D] = []
@export var padding: int = 10

var _text: Dictionary = {}


func _ready() -> void:
	_text = UiText.section("options")
	var ui := $Panel as Control
	if ui != null:
		ui.size = Menu.DESIGN_SIZE
		Menu.fit_control(ui)
		get_viewport().size_changed.connect(func() -> void:
			Menu.fit_control(ui)
		)
	_set_label($Panel/MusicLabel, _text.get("music", ""))
	_set_label($Panel/SfxLabel, _text.get("sfx", ""))
	_set_label($Panel/BackButton, _text.get("back", ""))
	if musicSlider != null:
		setMusicVolume(musicSlider.value)
	if sfxSlider != null:
		setSfxVolume(sfxSlider.value)
	updateShipButtonText()


func _set_label(node: Node, value: String) -> void:
	if node != null:
		node.set("text", value)


func setMusicVolume(v: float) -> void:
	_set_bus_volume("Music", v)


func setSfxVolume(v: float) -> void:
	_set_bus_volume("SFX", v)


func _set_bus_volume(bus_name: String, v: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx < 0:
		return
	if v <= 0.0001:
		AudioServer.set_bus_volume_db(idx, -80.0)
	else:
		AudioServer.set_bus_volume_db(idx, linear_to_db(v))


func backToMenu() -> void:
	var menu := get_parent()
	if menu and menu.has_method("show_main_menu"):
		menu.show_main_menu()
		return
	queue_free()


func cycleShipChoice() -> void:
	var ships: Array = _text.get("ships", [])
	var count := ship_textures.size()
	if count <= 0:
		count = ships.size()
	if count <= 0:
		return
	currentShipNumber += 1
	if currentShipNumber >= count:
		currentShipNumber = 0
	saveShipChoice()
	updateShipButtonText()


func saveShipChoice() -> void:
	var cf := ConfigFile.new()
	cf.load(SAVE_PATH)
	cf.set_value("data", "shipChoice", currentShipNumber)
	cf.save(SAVE_PATH)


func _ship_choice() -> Variant:
	var cf := ConfigFile.new()
	if cf.load(SAVE_PATH) != OK:
		return null
	if not cf.has_section_key("data", "shipChoice"):
		return null
	return cf.get_value("data", "shipChoice")


func updateShipButtonText() -> void:
	var ships: Array = _text.get("ships", [])
	var count := ship_textures.size()
	if count <= 0:
		count = ships.size()
	var choice = _ship_choice()
	if choice != null:
		currentShipNumber = int(choice)
	if count > 0 and (currentShipNumber < 0 or currentShipNumber >= count):
		currentShipNumber = 0
	var ship_name := str(_text.get("missing_ship", ""))
	if currentShipNumber >= 0 and currentShipNumber < ships.size():
		ship_name = str(ships[currentShipNumber])
	if shipButton != null:
		shipButton.text = ship_name
