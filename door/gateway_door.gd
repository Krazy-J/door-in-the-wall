tool
extends "res://door/door.gd"

export var exit_path : NodePath
onready var exit = get_node(exit_path)
export var requires_door = false

func _ready():
	if exit:
		if not has_node("Gateway"):
			if (not requires_door or has_node("Door")) and (not exit.requires_door or exit.has_node("Door")):
				connect_gateway()
		else:
			$Gateway.exit_path = "../" + str(exit_path) + "/Gateway"

func connect_gateway():
	add_child(load("res://gateway/DoorGateway.tscn").instance())
	$Gateway.exit_path = "../" + str(exit_path) + "/Gateway"
	if exit.has_node("Gateway") and exit.get_node("Gateway").rotation_degrees.y == 0: $Gateway.rotation_degrees.y += 180

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
			if $Interact.valid and not has_node("Door") and $"/root/Main/Player".carrying and get_node($"/root/Main/Player".carrying).has_node("Door"):
				if exit:
					connect_gateway()
					exit.connect_gateway()

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not open == is_open:
				if exit: exit.open = open
	elif has_node("Gateway/Area/Port"):
		if has_node("Door"):
			if $Door/AnimationPlayer.is_playing():
				is_open = $Door/AnimationPlayer.current_animation_position > 0.01
		if is_open:
			$Gateway.enable_viewport()
			$Gateway/Viewport.size = get_viewport().size / pow(2, ProjectSettings.door_mipmap_level)
			$Gateway/Viewport.shadow_atlas_size = ProjectSettings.door_shadow_atlas_size
		else:
			$Gateway.disable_viewport()
