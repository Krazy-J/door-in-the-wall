extends RigidBody

var teleport_linear_velocity : Vector3 setget set_teleport_linear_velocity
var teleport_angular_velocity : Vector3 setget set_teleport_angular_velocity
var carrying = false

func set_teleport_linear_velocity(set_teleport_linear_velocity):
	teleport_linear_velocity = set_teleport_linear_velocity
	linear_velocity += teleport_linear_velocity

func set_teleport_angular_velocity(set_teleport_angular_velocity):
	teleport_angular_velocity = set_teleport_angular_velocity
	angular_velocity += set_teleport_angular_velocity

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if carrying == true:
			if $"/root/Main/Player".carrying == self:
				$"/root/Main/Player".carrying = null
				$"/root/Main/Player".carry_distance = 0
			angular_damp = -1
			collision_layer = 3
			carrying = false
		elif $Interact.valid:
			$"/root/Main/Player".carrying = self
			$"/root/Main/Player".carry_distance = global_transform.origin.distance_to($"/root/Main/Player/PivotX".global_transform.origin)
			angular_damp = .95
			collision_layer = 2
			carrying = true

func _physics_process(_delta):
	if teleport_linear_velocity:
		linear_velocity -= teleport_linear_velocity
		angular_velocity -= teleport_angular_velocity
		teleport_linear_velocity = Vector3()
		teleport_angular_velocity = Vector3()
