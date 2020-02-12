extends Spatial

var falling
var speed = 0

func _input(event):
	if event.is_action_pressed("interact"):
		if $Door/Interact.visible and !$"/root/Main/Player".carrying:
			$"/root/Main/Player".carrying = get_path()
			falling = false
			speed = 0
		elif $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			falling = true

func _physics_process(delta):
	if falling:
		$Door.scale += (Vector3(1, 1, 1) - $Door.scale) * 3 * delta
		if $Door.translation.y > .3 * scale.z:
			speed += .5 * delta
			$Door.translation.y -= speed
		elif $Door.rotation_degrees.x > -90:
			speed -= $Door.rotation_degrees.x / 10 * delta
			$Door.rotation_degrees.x -= speed
			$Door.translation.y += (.3 * scale.z - $Door.translation.y) * 5 * delta
		else:
			$Door.rotation_degrees.x = -90
			$Door.translation.y = .3 * scale.z
			speed = 0
			falling = false
