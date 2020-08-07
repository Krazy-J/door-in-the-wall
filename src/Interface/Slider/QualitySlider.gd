tool
extends "res://src/Interface/Slider/Slider.gd"

export var values : PoolIntArray
export var names : PoolStringArray = ["Low", "Medium", "High"]
export var value_override = -1

func _ready():
	while len(values) < len(names): values.append(len(values))
	var value : int
	if value_override >= 0: value = value_override
	elif settings: while value < len(values) and not values[value] == ProjectSettings.get(settings[0]): value += 1
	elif viewport: while value < len(values) and not values[value] == get_viewport().get(viewport[0]): value += 1
	elif os: while value < len(values) and not values[value] == OS.get(os[0]): value += 1
	$Split/Slider.value = value
	update_quality(value)
	$Split/Slider.rect_min_size.x = 16 * len(names)
	$Split/Slider.max_value = len(names) - 1
	$Split/Slider.tick_count = len(names)

func update_quality(value):
	if names: $Split/Quality.text = names[value]
	$Split/Quality.modulate = Color(1,1,1)
	for v_name in ["Min","Off"]: if names[value] == v_name: $Split/Quality.modulate = Color(1,0,0)
	for v_name in ["Max","On","Full"]: if names[value] == v_name: $Split/Quality.modulate = Color(0,1,0)

func _value_changed(value):
	value = int(value)
	update_quality(value)
	if len(values): value = values[value]
	for setting in settings: ProjectSettings.set(setting, value)
	for property in viewport: get_viewport().set(property, value)
	for property in os: OS.set(property, value)

func _process(_delta):
	if Engine.editor_hint: _ready()
	else:
		var value = 0
		if settings:
			if len(values): while value < len(values) and not values[value] == ProjectSettings.get(settings[0]): value += 1
			else: if settings: value = ProjectSettings.get(settings[0])
		$Split/Slider.value = value
