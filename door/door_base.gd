extends Spatial

export var exit_door : NodePath
export var requires_door : bool
export var open : bool

func _ready():
	if exit_door and (!requires_door or has_node("Door")):
		add_child(load("res://door/DoorConnector.tscn").instance())
	if open and $Door:
		$Door/AnimationPlayer.play("DoorToggle")
		$Door/AnimationPlayer.seek(1)

func toggle_door():
	open = !open
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
		elif get_node($"/root/Player".carrying).name == "Door":
			add_child(load("res://door/sliding/SlidingDoor.tscn").instance())
			$Door.material_override = get_node($"/root/Player".carrying).material_override
			get_node($"/root/Player".carrying).queue_free()
			$"/root/Player".carrying = NodePath()
			if exit_door: add_child(load("res://door/DoorConnector.tscn").instance())
