extends Spatial

var falling
var tip_speed = 0

func _input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Player".carrying == get_path():
			$"/root/Player".carrying = NodePath()
			rotation_degrees.x -= 5
			falling = true
		elif $Interact.visible and !$"/root/Player".carrying:
			$"/root/Player".carrying = get_path()
			falling = false

func _physics_process(delta):
	if falling:
		scale += (Vector3(1, 1, 1) - scale) * delta
		if abs(rotation_degrees.x) < 90:
			tip_speed += rotation_degrees.x / 10 * delta
			rotation_degrees.x += tip_speed
		if abs(rotation_degrees.x) > 90:
			if rotation_degrees.x > 90: rotation_degrees.x = 90
			if rotation_degrees.x < -90: rotation_degrees.x = -90
			tip_speed = 0
			falling = false
