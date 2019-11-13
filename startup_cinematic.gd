extends Node

export var door : NodePath

func load_main():
	get_tree().change_scene("res://Main.tscn")

func _process(delta):
	get_node(door).transform.origin = Vector3(1.5, 3.25, -.125) - Vector3(1.5, 3.25, -.125).rotated(get_node(door).transform.basis.y, get_node(door).rotation_degrees.y / 180 * PI)
