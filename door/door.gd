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

func _on_Interact_area_entered(area):
	if area.name == "InteractArea": $Interact.visible = true

func _on_Interact_area_exited(area):
	if area.name == "InteractArea": $Interact.visible = false

func _input(event):
	if $Interact.visible and event.is_action_pressed("interact"):
		if has_node("Door"):
			toggle_door()
			if exit_door: get_node(exit_door).toggle_door()
		else:
			if has_node("/root/Player/Hands/Door"):
				add_child(load("res://door/sliding/SlidingDoor.tscn").instance())
				$Door.material_override = $"/root/Player/Hands/Door".material_override
				$"/root/Player/Hands/Door".queue_free()
				add_child(load("res://door/DoorConnector.tscn").instance())
