extends MeshInstance

export var room : PackedScene

func load_level():
	$"/root/Player".translation *= 0
	get_tree().change_scene(room.resource_path)

func _on_animation_finished(anim_name):
	load_level()
