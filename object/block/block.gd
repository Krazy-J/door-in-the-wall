extends RigidBody

func _input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Player".carrying == get_path(): $"/root/Player".carrying = NodePath()
		elif $Interact.visible and !$"/root/Player".carrying: $"/root/Player".carrying = get_path()
