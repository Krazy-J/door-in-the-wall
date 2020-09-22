tool extends "res://src/Door/Door.gd"

export var section_number : int
export var level_number : int
export(String, MULTILINE) var label setget set_label
export var label_color : Color setget set_label_color
var level

func _ready():
	if not Engine.editor_hint and door:
		level = ProjectSettings.levels[section_number][level_number]
		if level.locked:
			$Frame.material_override = load("res://assets/material/plastic/red.tres")
			set_locked(true)
		elif level_number and level.completed:
			$Frame.material_override = load("res://assets/material/plastic/yellow.tres")

func set_label(set_label):
	label = set_label
	$Label.text = label

func set_label_color(set_label_color):
	label_color = set_label_color
	$Label.color = label_color

# warning-ignore:return_value_discarded
func change_scene():
	get_viewport().call_deferred("add_child", load("res://src/Interface/Fade.tscn").instance())
	ProjectSettings.set("current_section", section_number)
	ProjectSettings.set("current_level", level_number)
	get_tree().change_scene("res://src/Room/" + level.scene + ".tscn")
