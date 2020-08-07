extends Spatial

export var drop_transform : Transform
var carrying = false

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if carrying == true:
			if $"/root/Main/Player".carrying == self:
				$"/root/Main/Player".carrying = null
			$Interact.global_transform = Transform()
			global_transform.origin = $"/root/Main/Player".global_transform.origin + $"/root/Main/Player".global_transform.basis * drop_transform.origin
			global_transform.basis = $"/root/Main/Player".global_transform.basis * drop_transform.basis
			carrying = false
		elif $Interact.valid:
			$"/root/Main/Player".carrying = self
			$Interact.global_transform = drop_transform
			carrying = true
