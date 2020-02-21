tool
extends "res://interface/slider/slider.gd"

export var min_value : float = 0
export var max_value : float = 100
export var step : float = 1
export var prefix : String
export var suffix : String
export var tick_count : int
export var value_override : float = -1

func _ready():
	$Split/Split/Slider.rect_min_size.x = 16 + ceil((max_value - min_value) / step)
	var value
	if not value_override == -1: value = value_override
	elif settings: value = ProjectSettings.get(settings[0])
	elif viewport: value = get_viewport().get(viewport[0])
	elif os: value = OS.get(os[0])
	$Split/Split/SpinBox.set_deferred("value",value)
	$Split/Split/Slider.set_deferred("value",value)
	$Split/Split/SpinBox.set_deferred("min_value",min_value)
	$Split/Split/Slider.set_deferred("min_value",min_value)
	$Split/Split/SpinBox.set_deferred("max_value",max_value)
	$Split/Split/Slider.set_deferred("max_value",max_value)
	$Split/Split/SpinBox.step = step
	$Split/Split/Slider.step = step
	$Split/Split/SpinBox.prefix = prefix
	$Split/Split/SpinBox.suffix = suffix
	$Split/Split/Slider.tick_count = tick_count
