tool
extends Spatial

func _process(_delta):
	if Engine.editor_hint:
		for door in get_children():
			door.translation.x = 4 * door.get_index() - 2 * (get_child_count() - 1)
