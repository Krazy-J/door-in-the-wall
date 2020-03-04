tool
extends "res://door/door.gd"

export var section = 0
export var level = 0
export(String, MULTILINE) var label setget set_label
export var label_color : Color setget set_label_color
var level_settings

func set_label(set_label):
	label = set_label
	$Label.text = label

func set_label_color(set_label_color):
	label_color = set_label_color
	$Label.color = label_color

func _ready():
	if not Engine.editor_hint and door:
		level_settings = ProjectSettings.levels[section][level]
		if level_settings.locked:
			material_override = load("res://object/plastic/red.tres")
			locked = true
		elif level_settings.completed:
			material_override = load("res://object/plastic/yellow.tres")

func load_fade(): get_viewport().call_deferred("add_child", load("res://interface/Fade.tscn").instance())
# warning-ignore:return_value_discarded
func load_scene():
	ProjectSettings.set("current_section", section)
	ProjectSettings.set("current_level", level)
	get_tree().change_scene("res://room/" + level_settings.scene + ".tscn")
