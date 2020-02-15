tool
extends "res://interface/slider/slider.gd"

export var values : PoolIntArray = [0, 1, 2]
export var names : PoolStringArray = ["Low", "Medium", "High"]
export var value_override = -1

func _ready():
	$Split/Label.text = label
	$Split/Split/Slider.rect_min_size.x = 16 * len(values)
	$Split/Split/Slider.max_value = len(values) - 1
	$Split/Split/Slider.tick_count = len(values)
	var value = 0
	if value_override >= 0: $Split/Split/Slider.value = value_override
	elif settings:
		while value < len(values) and not values[value] == ProjectSettings.get(settings[0]): value += 1
	elif root_properties:
		while value < len(values) and not values[value] == get_viewport().get(root_properties[0]): value += 1
	$Split/Split/Slider.value = value

func _value_changed(value):
	if names: $Split/Split/Quality.text = names[value]
	if names[value] == "Min" or names[value] == "Off": $Split/Split/Quality.modulate = Color(1,0,0)
	elif names[value] == "Max" or names[value] == "On" or names[value] == "Full": $Split/Split/Quality.modulate = Color(0,1,0)
	else: $Split/Split/Quality.modulate = Color(1,1,1)
	for setting in settings: ProjectSettings.set(setting, values[value])
	for property in root_properties: get_viewport().set(property, values[value])
