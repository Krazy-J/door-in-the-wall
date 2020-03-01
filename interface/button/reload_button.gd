extends BaseButton

export var node_path : NodePath
export var scene_path : PackedScene
onready var node_parent = get_node(node_path).get_parent()

func _on_button_down():
	get_node(node_path).queue_free()

func _on_button_up():
	node_parent.add_child(scene_path.instance())
