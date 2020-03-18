extends Node

var levels

func _pressed():
	levels = ProjectSettings.levels
	for section in levels.size():
		for level in levels[section].size():
			if levels[section][level].has("locked"): levels[section][level].locked = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://room/" + levels[0][0].scene + ".tscn")
