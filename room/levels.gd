tool
extends Spatial

export var section_number = 0
export var first_level = 1

func _process(_delta):
	if Engine.editor_hint:
		for door in get_children():
			door.section_number = section_number
			door.level_number = first_level + door.get_index()
			door.translation.x = 4 * door.get_index() - 2 * (get_child_count() - 1)
