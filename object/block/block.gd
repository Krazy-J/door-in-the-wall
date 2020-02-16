extends Spatial

var rigidbody

func create_rigidbody():
	rigidbody = load("res://object/block/BlockBody.tscn").instance()
	rigidbody.global_transform = global_transform
	get_parent().add_child(rigidbody)
	rigidbody = get_parent().get_child(get_parent().get_child_count() - 1)

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			$"/root/Main/Player".carry_distance = float()
			rigidbody.queue_free()
			rigidbody = null
		elif $Interact.visible and !$"/root/Main/Player".carrying:
			$"/root/Main/Player".carrying = get_path()
			$"/root/Main/Player".carry_distance = global_transform.origin.distance_to($"/root/Main/Player/PivotX".global_transform.origin)

func _physics_process(delta):
	if $"/root/Main/Player".carrying == get_path():
		pass
	else:
		if rigidbody:
			global_transform = rigidbody.global_transform
		else:
			create_rigidbody()
