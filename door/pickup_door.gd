extends GeometryInstance

func _input(event):
	if $Interact.visible and event.is_action_pressed("interact"):
		$"/root/Player/Hands".add_child(load("res://door/sliding/SlidingDoor.tscn").instance())
		$"/root/Player/Hands/Door".material_override = material_override
		queue_free()
