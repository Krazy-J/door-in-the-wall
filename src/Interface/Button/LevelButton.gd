extends Button

onready var level = ProjectSettings.levels[int(get_parent().name)][int(name)]

func _ready():
	if level.locked:
		modulate = Color(1,.6,.6)
		disabled = true
	elif level.completed:
		modulate = Color(1,1,.5)

# warning-ignore:return_value_discarded
func _pressed():
	ProjectSettings.set("current_section", int(get_parent().name))
	ProjectSettings.set("current_level", int(name))
	get_tree().change_scene("res://src/Room/" + level.scene + ".tscn")
