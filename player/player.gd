extends KinematicBody

export var speed = 100
export var jump_power = 25
export var air_resistance = .01
export var surface_friction = .2
export var gravity = 80
export var look_sensitivity = .003 # radians/pixel
export var carrying : NodePath
export var carry_distance : float
export var motion : Vector3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event.is_action_pressed("exit_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("left_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate(transform.basis.y.normalized(), -event.relative.x * look_sensitivity)
			$PivotX.rotate_x(-event.relative.y * look_sensitivity)
			$PivotX.rotation.x = clamp($PivotX.rotation.x, -1.5, 1.5)
		if event is InputEventJoypadMotion:
			rotate(transform.basis.y.normalized(), -event.relative.x * look_sensitivity)
			$PivotX.rotate_x(-event.relative.y * look_sensitivity)
			$PivotX.rotation.x = clamp($PivotX.rotation.x, -1.5, 1.5)
	if event.is_action_pressed("exit_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
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

func _physics_process(delta):
	if carrying:
		var body = get_node(carrying)
		if body.has_node("Door"):
			body.global_transform.origin += (global_transform.origin - body.global_transform.origin) * 10 * delta
			body.get_node("Door").translation += ($CarryDoor.translation / body.scale * scale - body.get_node("Door").scale * Vector3(0, 3.5, 0) - body.get_node("Door").translation) * 10 * delta
			if (global_transform.basis * (rotation_degrees - body.rotation_degrees)).y > 180:
				body.rotation_degrees += (rotation_degrees - body.rotation_degrees - global_transform.basis.y * 360) * 10 * delta
			elif (global_transform.basis * (rotation_degrees - body.rotation_degrees)).y < -180:
				body.rotation_degrees += (rotation_degrees - body.rotation_degrees + global_transform.basis.y * 360) * 10 * delta
			else:
				body.rotation_degrees += (rotation_degrees - body.rotation_degrees) * 10 * delta
			body.get_node("Door").rotation_degrees += ($CarryDoor.rotation_degrees - body.get_node("Door").rotation_degrees) * 10 * delta
			body.get_node("Door").scale += ($CarryDoor.scale - body.get_node("Door").scale) * 10 * delta
		else:
			body.linear_velocity = ($PivotX.global_transform.origin - $PivotX.global_transform.basis.z.normalized() * carry_distance - body.global_transform.origin) * 500 * delta
			body.angular_velocity = -body.rotation_degrees * 20 * delta
	motion += transform.basis * get_movement() * speed * delta
	if is_on_floor():
		motion *= (1 - surface_friction)
	motion *= (1 - air_resistance)
	motion -= global_transform.basis.y * gravity * delta
	motion = move_and_slide(motion, global_transform.basis.y.normalized())
