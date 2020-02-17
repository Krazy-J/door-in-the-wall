tool
extends "res://door/door.gd"

export(PackedScene) var room
export(String, MULTILINE) var label

func _ready():
	$Label.text = label

func load_fade(): get_viewport().call_deferred("add_child", load("res://interface/Fade.tscn").instance())
# warning-ignore:return_value_discarded
func load_scene(): get_tree().change_scene(room.resource_path)

func _process(_delta):
	if Engine.editor_hint:
		$Label.text = label
