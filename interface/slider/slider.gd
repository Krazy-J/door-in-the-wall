tool
extends Control

export var setting = ""
export var label = "name"
export var min_value = 0.0
export var max_value = 100.0
export var step = 1.0
export var value = 0.0
export var prefix = ""
export var suffix= ""
export var tick_count = 0

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
	if setting: ProjectSettings.set(setting, value)
