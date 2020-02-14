tool
extends BaseButton

export var popup : NodePath

func _pressed():
	get_node(popup).popup()
