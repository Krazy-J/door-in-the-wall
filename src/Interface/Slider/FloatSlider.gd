tool extends "res://src/Interface/Slider/Slider.gd"

export var min_value : float = 0
export var max_value : float = 100
export var step : float = 1
export var prefix : String
export var suffix : String
export var tick_count : int
export var value_override : float = -1

func _ready():
	$Split/Slider.rect_min_size.x = 16 + ceil((max_value - min_value) / step)
	var value
	if not value_override == -1: value = value_override
	elif settings: value = ProjectSettings.get(settings[0])
	elif viewport: value = get_viewport().get(viewport[0])
	elif os: value = OS.get(os[0])
	$Split/SpinBox.step = step
	$Split/Slider.step = step
	$Split/SpinBox.prefix = prefix
	$Split/SpinBox.suffix = suffix
	$Split/Slider.tick_count = tick_count
	$Split/SpinBox.min_value = min_value
	$Split/Slider.min_value = min_value
	$Split/SpinBox.max_value = max_value
	$Split/Slider.max_value = max_value
	$Split/SpinBox.value = value
	$Split/Slider.value = value

func _process(_delta):
	if Engine.editor_hint: _ready()
