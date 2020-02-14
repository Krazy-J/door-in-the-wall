extends Spatial

export var room : PackedScene

func load_fade():
	$"/root".call_deferred("add_child", load("res://interface/Fade.tscn").instance())

func load_level():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(room.resource_path)
