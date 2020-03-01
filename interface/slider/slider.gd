tool
extends Control

export var settings : PoolStringArray
export var viewport : PoolStringArray
export var os : PoolStringArray
export var label : String = "name"

func _ready():
	$Split/Label.text = label

func _value_changed(value):
	$Split/Split/SpinBox.value = value
	$Split/Split/Slider.value = value
	for setting in settings: ProjectSettings.set(setting, value)
	for property in viewport: get_viewport().set(property, value)
	for property in os: OS.set(property, value)

func _process(_delta):
	if Engine.editor_hint: _ready()
