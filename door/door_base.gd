tool
extends Node

export var exit : NodePath
export var requires_door = false
export var open = false
var is_open = open
export var door : PackedScene
export var door_mesh : Mesh
export var door_material : Material

func _ready():
	if door:
		add_child(door.instance())
		if door_mesh: $Door.mesh = door_mesh
		$Door.material_override = door_material.duplicate()
	if exit and not has_node("Gateway") and (!requires_door or has_node("Door")):
		connect_gateway()

func connect_gateway():
	add_child(load("res://gateway/DoorGateway.tscn").instance())
	$Gateway.exit = "../" + str(exit) + "/Gateway"
	if get_node(exit).has_node("Gateway"): $Gateway.rotation_degrees.y += 180

func toggle_door():
	open = not open
	if open:
		$Door/AnimationPlayer.play("DoorToggle")
		$Door/SoundClose.stop()
		$Door/SoundOpen.play($Door/AnimationPlayer.current_animation_position)
	else:
		$Door/AnimationPlayer.play_backwards("DoorToggle")
		$Door/SoundOpen.stop()
		$Door/SoundClose.play(1 - $Door/AnimationPlayer.current_animation_position)

func _unhandled_input(event):
	if event.is_action_pressed("interact") and ($Interact.visible or has_node("Door") and $Door/Interact.visible):
		if has_node("Door"):
			toggle_door()
			if exit: get_node(exit).toggle_door()
		elif $"/root/Main/Player".carrying and get_node($"/root/Main/Player".carrying).has_node("Door"):
			add_child(get_node($"/root/Main/Player".carrying).door.instance())
			if door_mesh: $Door.mesh = get_node($"/root/Main/Player".carrying).door_mesh
			$Door.material_override = get_node($"/root/Main/Player".carrying).door_material
			if exit: connect_gateway()
			get_node($"/root/Main/Player".carrying).queue_free()

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not open == is_open and not $Door/AnimationPlayer.is_playing():
				if open:
					$Door/AnimationPlayer.play("DoorToggle")
					$Door/SoundOpen.play()
				else:
					$Door/AnimationPlayer.play_backwards("DoorToggle")
					$Door/SoundClose.play()
				if exit: get_node(exit).open = open
			if not door_material == $Door.material_override: $Door.material_override = door_material
		elif door: add_child(door.instance())
	elif exit and has_node("Door"):
		if is_open:
			$Gateway.enable_viewport($"/root/Main/Player/TeleportArea")
		else:
			$Gateway.disable_viewport($"/root/Main/Player/TeleportArea")
