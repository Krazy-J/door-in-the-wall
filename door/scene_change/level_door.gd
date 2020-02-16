tool
extends "res://door/door.gd"

export var room : PackedScene

func load_fade(): get_viewport().call_deferred("add_child", load("res://interface/Fade.tscn").instance())
# warning-ignore:return_value_discarded
func load_scene(): get_tree().change_scene(room.resource_path)
