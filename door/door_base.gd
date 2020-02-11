tool
extends Spatial

export var exit_door = NodePath()
export var requires_door = false
export var open = false
export var door : PackedScene
export var door_mesh : Mesh
export var door_material : Material

func _ready():
	if door:
		add_child(door.instance())
		if door_mesh: $Door.mesh = door_mesh
		$Door.material_override = door_material
	if exit_door and (!requires_door or has_node("Door")) and not Engine.editor_hint:
		add_child(load("res://door/DoorConnector.tscn").instance())

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

func _input(event):
	if event.is_action_pressed("interact") and ($Interact.visible or has_node("Door") and $Door/Interact.visible):
		if has_node("Door"):
			toggle_door()
			if exit_door: get_node(exit_door).toggle_door()
		elif get_node($"/root/Player".carrying).has_node("Door"):
			add_child(load("res://door/sliding/SlidingDoor.tscn").instance())
			$Door.material_override = get_node($"/root/Player".carrying).get_node("Door").material_override
			if exit_door: add_child(load("res://door/DoorConnector.tscn").instance())
			get_node($"/root/Player".carrying).queue_free()

var is_open = false
# warning-ignore:unused_argument
func _process(delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not open == is_open:
				if open:
					$Door/AnimationPlayer.play("DoorToggle")
					$Door/SoundOpen.play()
				else:
					$Door/AnimationPlayer.play_backwards("DoorToggle")
					$Door/SoundClose.play()
				is_open = open
				if exit_door: get_node(exit_door).open = open
			if not door_material == $Door.material_override: $Door.material_override = door_material
		elif door: add_child(door.instance())
