tool
extends "res://door/scene_change/level_door.gd"

# warning-ignore:return_value_discarded
func load_scene(): get_tree().change_scene("res://room/Lobby.tscn")
