extends Spatial

export var drop_transform : Transform

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			global_transform.origin = $"/root/Main/Player".global_transform.origin + $"/root/Main/Player".global_transform.basis * drop_transform.origin
			global_transform.basis = $"/root/Main/Player".global_transform.basis * drop_transform.basis
		elif $Interact.valid and !$"/root/Main/Player".carrying:
			$"/root/Main/Player".carrying = get_path()
