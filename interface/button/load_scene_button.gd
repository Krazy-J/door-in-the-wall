extends BaseButton

export var scene : PackedScene
export var load_as_child : bool

func _pressed():
	if load_as_child:
		get_parent().add_child(scene.instance())
	else:
		# warning-ignore:return_value_discarded
		get_tree().change_scene(scene.resource_path)
