extends KinematicBody

export var view_distance = 100
export var speed = 100
export var jump_power = 25
export var air_resistance = .01
export var surface_friction = .2
export var gravity = 80
var motion : Vector3
var interact : Node
var carrying : Node
var carry_distance : float

func _ready():
	$PivotX/Camera.far = view_distance
	if not has_node("../LobbyDoor"):
		$Pause/List/QuitLevel.disabled = true
		$Pause/List/QuitLevel.hint_tooltip = "You're not in a level!"
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_level():
	get_node("../LobbyDoor").toggle_door()

func _on_quit_menu():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")
	$"/root".call_deferred("add_child", load("res://interface/Fade.tscn").instance())

func _on_save_and_exit_game():
	var save = File.new()
	save.open("res://save.json", File.WRITE)
	save.store_line(to_json(ProjectSettings.levels))
	save.close()
	get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("exit_mouse"): $Pause.popup()
	if event.is_action_pressed("fullscreen"): OS.window_fullscreen = not OS.window_fullscreen
	if not $Pause.visible:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				if Input.is_mouse_button_pressed(BUTTON_MIDDLE) and carrying:
					var body = carrying
					body.rotate(transform.basis.y.normalized(), -event.relative.x * ProjectSettings.mouse_sensitivity)
					if not body.is_class("StaticBody"): body.rotate(transform.basis.x.normalized(), -event.relative.y * ProjectSettings.mouse_sensitivity)
				else:
					rotate(transform.basis.y.normalized(), -event.relative.x * ProjectSettings.mouse_sensitivity)
					$PivotX.rotate_x(-event.relative.y * ProjectSettings.mouse_sensitivity)
					$PivotX.rotation.x = clamp($PivotX.rotation.x, -1.5, 1.5)
			if event is InputEventJoypadMotion:
				rotate(transform.basis.y.normalized(), -event.relative.x * ProjectSettings.mouse_sensitivity)
				$PivotX.rotate_x(-event.relative.y * ProjectSettings.mouse_sensitivity)
				$PivotX.rotation.x = clamp($PivotX.rotation.x, -1.5, 1.5)
		if carrying and event is InputEventMouseButton:
			if Input.is_mouse_button_pressed(BUTTON_WHEEL_UP):
				carry_distance = min(carry_distance + .1, abs($PivotX/Interact.cast_to.z))
			if Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN):
				carry_distance = max(carry_distance - .1, 2)
		if is_on_floor():
			if event.is_action("jump"): motion += transform.basis.y * jump_power

func get_movement():
	var movement : Vector3
	#print(Input.get_joy_axis(1, JOY_ANALOG_RX), 0, Input.get_joy_axis(1, JOY_ANALOG_RY))
	if Input.is_class("InputEventJoypadMotion"):
		movement = Vector3(Input.get_joy_axis(-1, JOY_ANALOG_RX), 0, Input.get_joy_axis(-1, JOY_ANALOG_RY))
	else:
		if Input.is_key_pressed(KEY_W): movement.z -= 1
		if Input.is_key_pressed(KEY_S): movement.z += 1
		if Input.is_key_pressed(KEY_A): movement.x -= 1
		if Input.is_key_pressed(KEY_D): movement.x += 1
		movement = movement.normalized()
		if Input.is_key_pressed(KEY_SHIFT): movement *= 2
	if !is_on_floor(): movement /= 20
	return movement

func _process(_delta):
	$PivotX/Camera.fov = ProjectSettings.fov
	if not interact == $PivotX/Interact.get_collider():
		if interact:
			interact.interact_exited()
			interact = null
		if $PivotX/Interact.is_colliding() and $PivotX/Interact.get_collider().has_node("Interact"):
			interact = $PivotX/Interact.get_collider().get_node("Interact")
			interact.interact_entered()

func _physics_process(delta):
	if not $Pause.visible:
		if carrying:
			if carrying.has_node("Door"):
				carrying.global_transform.origin += (transform.origin - carrying.global_transform.origin) * 10 * delta
				carrying.get_node("Door").translation += ($CarryDoor.translation / carrying.scale * scale - carrying.get_node("Door").scale * Vector3(0, 3.5, 0) - carrying.get_node("Door").translation) * 10 * delta
				if (transform.basis * (rotation_degrees - carrying.rotation_degrees)).y > 180:
					carrying.rotation_degrees += (rotation_degrees - carrying.rotation_degrees - transform.basis.y * 360) * 10 * delta
				elif (transform.basis * (rotation_degrees - carrying.rotation_degrees)).y < -180:
					carrying.rotation_degrees += (rotation_degrees - carrying.rotation_degrees + transform.basis.y * 360) * 10 * delta
				else:
					carrying.rotation_degrees += (rotation_degrees - carrying.rotation_degrees) * 10 * delta
				carrying.get_node("Door").rotation_degrees += ($CarryDoor.rotation_degrees - carrying.get_node("Door").rotation_degrees) * 10 * delta
				carrying.get_node("Door").scale += ($CarryDoor.scale - carrying.get_node("Door").scale) * 10 * delta
			elif carrying.is_class("StaticBody"):
				carrying.constant_linear_velocity = ($PivotX.global_transform.origin - $PivotX.global_transform.basis.z.normalized() * carry_distance - carrying.global_transform.origin) * 500 * delta
			elif carrying.is_class("RigidBody"):
				carrying.linear_velocity = ($PivotX.global_transform.origin - $PivotX.global_transform.basis.z.normalized() * carry_distance - carrying.global_transform.origin) * 500 * delta
			else:
				carrying.global_transform = $PivotX/Carry.global_transform
		motion += transform.basis * get_movement() * speed * delta
		if is_on_floor():
			motion *= (1 - surface_friction)
		motion *= (1 - air_resistance)
		motion -= transform.basis.y * gravity * delta
		motion = move_and_slide(motion, transform.basis.y.normalized())
