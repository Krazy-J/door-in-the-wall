tool
extends Spatial

export var on : bool = true setget set_on
export var material : Material
export var lights : Array
export var nodes : Array

func _ready():
	$Panel.material = material

func set_on(set_on):
	on = set_on
	$SwitchOn.visible = on
	$SwitchOff.visible = not on
	for light in lights: get_node(light).on = on
	for node in nodes: get_node(node).visible = on

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $Interact.valid: set_on(not on)
