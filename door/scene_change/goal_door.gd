tool
extends "res://door/scene_change/level_door.gd"

onready var levels = ProjectSettings.levels
onready var current_section = ProjectSettings.current_section
onready var current_level = ProjectSettings.current_level

# warning-ignore:return_value_discarded
func load_scene():
	if not levels[current_section][current_level].completed:
		levels[current_section][current_level].completed = true
		if levels[current_section].size() >= current_level:
			 levels[current_section][current_level + 1].locked = false
	ProjectSettings.set("levels", levels)
	get_tree().change_scene("res://room/" + level.scene + ".tscn")
