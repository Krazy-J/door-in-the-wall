tool
extends "res://door/door.gd"

export var exit : NodePath
export var requires_door = false

func _ready():
	if exit:
		if not has_node("Gateway") and (!requires_door or has_node("Door")):
			connect_gateway()
		else:
			$Gateway.exit = "../" + str(exit) + "/Gateway"

func connect_gateway():
	add_child(load("res://gateway/DoorGateway.tscn").instance())
	$Gateway.exit = "../" + str(exit) + "/Gateway"
	if get_node(exit).has_node("Gateway"): $Gateway.rotation_degrees.y += 180

func _unhandled_input(event):
	if event.is_action_pressed("interact") and ($Interact.visible or has_node("Door") and $Door/Interact.visible):
		if has_node("Door"):
			if exit: get_node(exit).toggle_door()
		elif $"/root/Main/Player".carrying and get_node($"/root/Main/Player".carrying).has_node("Door"):
			if exit: connect_gateway()

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not open == is_open:
				if exit: get_node(exit).open = open
	elif exit and has_node("Door") and $Door/AnimationPlayer.is_playing():
		if $Door/AnimationPlayer.current_animation_position <= 0.01:
			$Gateway.disable_viewport($"/root/Main/Player/TeleportArea")
		else:
			$Gateway.enable_viewport($"/root/Main/Player/TeleportArea")
