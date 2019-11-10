extends Spatial

var falling
var tip_speed = 0

func _input(event):
	if event.is_action_pressed("interact"):
		if $Door/Interact.visible and !$"/root/Player".carrying:
			$"/root/Player".carrying = get_path()
			falling = false
		elif $"/root/Player".carrying == get_path():
			$"/root/Player".carrying = NodePath()
			falling = true

func _physics_process(delta):
	if falling:
		scale += (Vector3(1, 1, 1) - scale) * delta
		if $Door.rotation_degrees.x > -90:
			tip_speed += $Door.rotation_degrees.x / 10 * delta
			$Door.rotation_degrees.x += tip_speed
		if $Door.rotation_degrees.x < -90:
			$Door.rotation_degrees.x = -90
			tip_speed = 0
			falling = false
