extends RigidBody

func _input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Player".carrying == get_path():
			$"/root/Player".carrying = NodePath()
			$"/root/Player".carry_distance = float()
		elif $Interact.visible and !$"/root/Player".carrying:
			$"/root/Player".carrying = get_path()
			$"/root/Player".carry_distance = global_transform.origin.distance_to($"/root/Player/PivotX".global_transform.origin)
