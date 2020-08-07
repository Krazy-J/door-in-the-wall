tool
extends "res://src/Interface/Slider/Slider.gd"

export var values : PoolIntArray = [0, 1, 2]
export var names : PoolStringArray = ["Low", "Medium", "High"]
export var value_override = -1

func _ready():
	var value = 0
	if value_override >= 0: value = value_override
	elif settings:
		while value < len(values) and not values[value] == ProjectSettings.get(settings[0]): value += 1
	elif viewport:
		while value < len(values) and not values[value] == get_viewport().get(viewport[0]): value += 1
	elif os:
		while value < len(values) and not values[value] == OS.get(os[0]): value += 1
	$Split/Split/Slider.value = value
	_value_changed(value)
	$Split/Split/Slider.rect_min_size.x = 16 * len(values)
	$Split/Split/Slider.max_value = len(values) - 1
	$Split/Split/Slider.tick_count = len(values)

func _value_changed(value):
	if names: $Split/Split/Quality.text = names[value]
	$Split/Split/Quality.modulate = Color(1,1,1)
	for v_name in ["Min","Off"]: if names[value] == v_name: $Split/Split/Quality.modulate = Color(1,0,0)
	for v_name in ["Max","On","Full"]: if names[value] == v_name: $Split/Split/Quality.modulate = Color(0,1,0)
	for setting in settings: ProjectSettings.set(setting, values[value])
	for property in viewport: get_viewport().set(property, values[value])
	for property in os: OS.set(property, values[value])

func _process(_delta):
	if Engine.editor_hint: _ready()
	var value = 0
	if settings: while value < len(values) and not values[value] == ProjectSettings.get(settings[0]): value += 1
	$Split/Split/Slider.value = value
