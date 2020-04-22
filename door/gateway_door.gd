tool
extends "res://door/door.gd"

export var exit_path : NodePath
export var requires_door = false
onready var exit setget set_exit


func _ready():
	set_exit(exit)

func set_exit(_set_exit):
	if exit_path:
		exit = get_node(exit_path)
		if not Engine.editor_hint:
			if not has_node("Gateway"):
				if (not requires_door or door) and (not exit.requires_door or exit.door):
					connect_gateway()
			else:
				$Gateway.exit_path = "../" + str(exit_path) + "/Gateway"
	else: exit = null

func set_door(set_door):
	door = set_door
	if door:
		add_child(door.instance())
	elif has_node("Door"): $Door.queue_free()
	if exit and not exit.door == door: exit.door = door

func set_door_mesh(set_door_mesh):
	door_mesh = set_door_mesh
	if door:
		if door_mesh: $Door.mesh = door_mesh
		else: $Door.mesh = door.instance().mesh
	if exit and not exit.door_mesh == door_mesh: exit.door_mesh = door_mesh

func set_door_material(set_door_material):
	door_material = set_door_material
	if door and door_material:
		if door_material: $Door.material = door_material.duplicate()
		else: $Door.material = null
	if exit and not exit.door_material == door_material: exit.door_material = door_material

func set_open(set_open):
	if door:
		if Engine.editor_hint and not is_open == set_open:
			open = not set_open
			toggle_door()
			is_open = set_open
			if exit and not exit.open == open: exit.open = open
		elif not $Door/AnimationPlayer.is_playing():
			open = set_open
			if open:
				$Door/AnimationPlayer.play("door_toggle")
				$Door/AnimationPlayer.seek($Door/AnimationPlayer.current_animation_length)
			else:
				$Door/AnimationPlayer.play_backwards("door_toggle")
				$Door/AnimationPlayer.seek(0)

func connect_gateway():
	add_child(load("res://gateway/DoorGateway.tscn").instance())
	$Gateway.exit_path = "../" + str(exit_path) + "/Gateway"
	if exit.has_node("Gateway") and exit.get_node("Gateway").rotation_degrees.y == 0: $Gateway.rotation_degrees.y += 180

func update_interact():
	if door:
		if $Door/Body/Interact.focused: $Frame/Interact.update_valid()
		if not $Frame/Interact.focused: $Frame/Interact.visible = $Door/Body/Interact.focused
		if $Frame/Interact.focused: $Door/Body/Interact.update_valid()
		if not $Door/Body/Interact.focused: $Door/Body/Interact.visible = $Frame/Interact.focused
		if $Frame/Interact.visible and $Door/AnimationPlayer.current_animation == "unlock":
			$Frame/Interact.update_valid()
	if exit and (exit.get_node("Frame/Interact").focused or exit.door and exit.get_node("Door/Body/Interact").focused):
			$Frame/Interact.update_valid()
			$Frame/Interact.visible = exit.get_node("Frame/Interact").visible
			if exit.door:
				$Door/Body/Interact.update_valid()
				$Door/Body/Interact.visible = exit.get_node("Door/Body/Interact").visible

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if has_node("Door") and ($Frame/Interact.valid or $Door/Body/Interact.valid):
			if locked and $"/root/Main/Player".carrying and $"/root/Main/Player".carrying.name == "Key":
				if exit: exit.unlock()
			elif exit and (not locked or exit.locked): exit.toggle_door()
		if $Frame/Interact.valid and not door and $"/root/Main/Player".carrying and $"/root/Main/Player".carrying.has_node("Door"):
			if exit:
				connect_gateway()
				exit.connect_gateway()

func _process(_delta):
	if not Engine.editor_hint:
		if has_node("Gateway/Area/Port"):
			if door and $Door/AnimationPlayer.is_playing():
				is_open = $Door/AnimationPlayer.current_animation_position > 0.01
			if is_open:
				$Gateway.enable_viewport()
				$Gateway/Viewport.size = get_viewport().size / pow(2, ProjectSettings.door_mipmap_level)
				$Gateway/Viewport.shadow_atlas_size = ProjectSettings.door_shadow_atlas_size
			else:
				$Gateway.disable_viewport()
