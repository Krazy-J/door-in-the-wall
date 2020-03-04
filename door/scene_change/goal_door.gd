tool
extends "res://door/scene_change/level_door.gd"

onready var levels = ProjectSettings.levels
onready var current_section = ProjectSettings.current_section
onready var current_level = ProjectSettings.current_level

# warning-ignore:return_value_discarded
func load_scene():
	if not levels[current_section][current_level].completed:
		levels[current_section][current_level].completed = true
		ProjectSettings.set("completed_levels", ProjectSettings.completed_levels + 1)
		if levels[current_section].size() >= current_level + 1:
			 levels[current_section][current_level + 1].locked = false
	print(levels)
	ProjectSettings.set("levels", levels)
	get_tree().change_scene("res://room/" + level_settings.scene + ".tscn")
