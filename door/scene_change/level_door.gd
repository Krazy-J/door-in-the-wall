tool
extends "res://door/door.gd"

export var section_number = 0
export var level_number = 0
export(String, MULTILINE) var label setget set_label
export var label_color : Color setget set_label_color
var level

func set_label(set_label):
	label = set_label
	$Label.text = label

func set_label_color(set_label_color):
	label_color = set_label_color
	$Label.color = label_color

func _ready():
	if not Engine.editor_hint and door:
		level = ProjectSettings.levels[section_number][level_number]
		if level.locked:
			material_override = load("res://object/plastic/red.tres")
			locked = true
		elif level_number and level.completed:
			material_override = load("res://object/plastic/yellow.tres")

func load_fade(): get_viewport().call_deferred("add_child", load("res://interface/Fade.tscn").instance())
# warning-ignore:return_value_discarded
func load_scene():
	ProjectSettings.set("current_section", section_number)
	ProjectSettings.set("current_level", level_number)
	get_tree().change_scene("res://room/" + level.scene + ".tscn")
