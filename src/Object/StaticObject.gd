extends StaticBody

export var weight : float = 20
onready var rays = {
	$Ray/CastDown:true,
	$Ray/Cast1:true,
	$Ray/Cast2:true,
	$Ray/Cast3:true,
	$Ray/Cast4:true,
	$Ray/Cast5:false,
	$Ray/Cast6:false,
	$Ray/Cast7:false,
	$Ray/Cast8:false,
}
var carrying = false

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if carrying == true:
			if $"/root/Main/Player".carrying == self:
				$"/root/Main/Player".carrying = null
				$"/root/Main/Player".carry_distance = 0
			for ray in $Ray.get_children(): ray.enabled = true
			collision_layer = 3
			carrying = false
		elif $Interact.valid:
			for ray in $Ray.get_children(): ray.enabled = true
			collision_layer = 2
			constant_linear_velocity = Vector3()
			$"/root/Main/Player".carrying = self
			$"/root/Main/Player".carry_distance = global_transform.origin.distance_to($"/root/Main/Player/PivotX".global_transform.origin)
			carrying = true

func _physics_process(delta):
	if $Ray/CastDown.enabled:
		var collisions = []
		for ray in $Ray.get_children():
			if ray.is_colliding():
				collisions.append(ray.get_collision_point() - global_transform.origin - global_transform.basis * ray.cast_to)
				if not carrying:
					if ray == $Ray/CastDown: for ray in $Ray.get_children(): ray.enabled = false
					constant_linear_velocity = Vector3()
				if not rays[ray]:
					$SoundThud.play()
					rays[ray] = true
			else: rays[ray] = false
		var collision_point = Vector3()
		for collision in collisions: collision_point += collision / len(collisions)
		global_transform.origin += collision_point
		constant_linear_velocity -= global_transform.basis.y.normalized() * weight * delta
		constant_linear_velocity /= 1 + delta
		global_transform.origin += constant_linear_velocity * delta
