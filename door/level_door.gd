extends Spatial

export var room : PackedScene

func load_level():
	$"/root/Player".translation = Vector3()
	$"/root/Player".scale = Vector3(1, 1, 1)
	get_tree().change_scene(room.resource_path)
	$"/root".call_deferred("add_child", load("res://FadeSplash.tscn").instance())
