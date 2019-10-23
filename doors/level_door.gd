extends MeshInstance

export var room = ""

func load_level():
	get_tree().change_scene("res://rooms/"+room+".tscn")
	get_node("/root").add_child(load("res://player/Player.tscn").instance())
