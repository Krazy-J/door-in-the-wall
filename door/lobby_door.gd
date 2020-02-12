extends Spatial

func load_fade_splash():
	$"/root".call_deferred("add_child", load("res://interface/FadeSplash.tscn").instance())

func load_level():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://room/Lobby.tscn")
