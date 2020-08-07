tool
extends "res://src/Door/SceneChange/LevelDoor.gd"

# warning-ignore:return_value_discarded
func change_scene():
	get_viewport().call_deferred("add_child", load("res://src/Interface/Fade.tscn").instance())
	
	var levels = ProjectSettings.levels
	var current_section = ProjectSettings.current_section
	var current_level = ProjectSettings.current_level
	if not levels[current_section][current_level].completed:
		levels[current_section][current_level].completed = true
		if levels[current_section].size() > current_level + 1:
			levels[current_section][current_level + 1].locked = false
		ProjectSettings.set("levels", levels)
	
	get_tree().change_scene("res://src/Room/" + level.scene + ".tscn")
