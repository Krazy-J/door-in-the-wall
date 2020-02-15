tool
extends "res://interface/slider/slider.gd"

export var min_value : int
export var max_value : int = 100
export var step : int = 1
export var value : int
export var prefix : String
export var suffix : String
export var tick_count : int

func _ready():
	$Split/Label.text = label
	$Split/Split/Slider.rect_min_size.x = 16 + ceil((max_value - min_value) / step)
	$Split/Split/SpinBox.value = value
	$Split/Split/Slider.value = value
	$Split/Split/SpinBox.min_value = min_value
	$Split/Split/Slider.min_value = min_value
	$Split/Split/SpinBox.max_value = max_value
	$Split/Split/Slider.max_value = max_value
	$Split/Split/SpinBox.step = step
	$Split/Split/Slider.step = step
	$Split/Split/SpinBox.prefix = prefix
	$Split/Split/SpinBox.suffix = suffix
	$Split/Split/Slider.tick_count = tick_count

func _value_changed(new_value):
	value = new_value
	$Split/Split/SpinBox.value = value
	$Split/Split/Slider.value = value
	for setting in settings: ProjectSettings.set(setting, value)
	for property in root_properties: get_viewport().set(property, value)
