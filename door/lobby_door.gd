extends Spatial

func load_level():
	$"/root/Player".translation = Vector3()
	$"/root/Player".scale = Vector3(1, 1, 1)
	get_tree().change_scene("res://room/Lobby.tscn")
	$"/root".call_deferred("add_child", load("res://FadeSplash.tscn").instance())