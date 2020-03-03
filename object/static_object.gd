extends StaticBody

export var weight = 20.0
var on_floor = true

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			$"/root/Main/Player".carry_distance = 0
			$Down.enabled = true
			collision_layer = 5
		elif $Interact.valid and not $"/root/Main/Player".carrying:
			$Down.enabled = true
			collision_layer = 4
			constant_linear_velocity = Vector3()
			$"/root/Main/Player".carrying = get_path()
			$"/root/Main/Player".carry_distance = global_transform.origin.distance_to($"/root/Main/Player/PivotX".global_transform.origin)

func _physics_process(delta):
	if $Down.enabled:
		if $Down.is_colliding():
			global_transform.origin = $Down.get_collision_point() + global_transform.basis.y
			if not $"/root/Main/Player".carrying:
				$Down.enabled = false
				constant_linear_velocity = Vector3()
			if not on_floor:
				$SoundThud.play()
				on_floor = true
		else: on_floor = false
		constant_linear_velocity -= global_transform.basis.y.normalized() * weight * delta
		constant_linear_velocity /= 1 + delta
		global_transform.origin += constant_linear_velocity * delta
