tool extends Control

export var settings : PoolStringArray
export var viewport : PoolStringArray
export var os : PoolStringArray
export var label : String = "name" setget set_label

func set_label(set_label):
	label = set_label
	$Label.text = label

func _value_changed(value):
	$Split/SpinBox.value = value
	$Split/Slider.value = value
	for setting in settings: ProjectSettings.set(setting, value)
	for property in viewport: get_viewport().set(property, value)
	for property in os: OS.set(property, value)
