extends RigidBody

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			$"/root/Main/Player".carry_distance = float()
		elif $Interact.valid and !$"/root/Main/Player".carrying:
			$"/root/Main/Player".carrying = get_path()
			$"/root/Main/Player".carry_distance = global_transform.origin.distance_to($"/root/Main/Player/PivotX".global_transform.origin)
