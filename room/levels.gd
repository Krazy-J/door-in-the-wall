tool
extends Spatial

export var section = 0
export var first_level = 1

func _process(_delta):
	if Engine.editor_hint:
		for door in get_children():
			door.section = section
			door.level = first_level + door.get_index()
			door.translation.x = 4 * door.get_index() - 2 * (get_child_count() - 1)
