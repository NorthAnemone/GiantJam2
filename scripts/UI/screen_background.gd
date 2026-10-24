@tool
extends TextureRect

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_SCALE
	if not resized.is_connected(_fit_width):
		resized.connect(_fit_width)
	_fit_width()


func _fit_width() -> void:
	if texture == null or texture.get_width() == 0:
		return
	var width := size.x
	if width <= 1.0:
		width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height := width * float(texture.get_height()) / float(texture.get_width())
	if anchor_right == 1.0 and is_equal_approx(offset_bottom, height):
		return
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 1.0
	anchor_bottom = 0.0
	offset_left = 0.0
	offset_right = 0.0
	offset_top = 0.0
	offset_bottom = height
