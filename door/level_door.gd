extends Spatial

export var room : PackedScene

func add_fade_splash():
	$"/root".call_deferred("add_child", load("res://FadeSplash.tscn").instance())

func load_level():
	$"/root/Player".transform = Transform()
	get_tree().change_scene(room.resource_path)
