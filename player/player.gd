extends KinematicBody

export var speed = 100
export var jump_power = 25
export var air_resistance = .01
export var surface_friction = .2
export var gravity = 80
export var mouse_sensitivity = .003 # radians/pixel
export var carrying : NodePath
var motion : Vector3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("left_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("exit_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate(transform.basis.y.normalized(), -event.relative.x * mouse_sensitivity)
		$PivotX.rotate_x(-event.relative.y * mouse_sensitivity)
		$PivotX.rotation.x = clamp($PivotX.rotation.x, -1.5, 1.5)
	if event.is_action_pressed("exit_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if is_on_floor():
		if event.is_action_pressed("jump"): motion += transform.basis.y * jump_power

func get_movement():
	var movement : Vector3
	if Input.is_action_pressed("move_forward"): movement.z -= 1
	if Input.is_action_pressed("move_back"): movement.z += 1
	if Input.is_action_pressed("move_left"): movement.x -= 1
	if Input.is_action_pressed("move_right"): movement.x += 1
	movement = movement.normalized()
	if Input.is_action_pressed("sprint"): movement *= 2
	if !is_on_floor(): movement /= 20
	return movement

func _physics_process(delta):
	if carrying:
		var body = get_node(carrying)
		if body.has_node("Door"):
			body.translation += ($Carry/Door.global_transform.origin - body.global_transform.origin) / 5
			body.rotation_degrees += (rotation_degrees - body.rotation_degrees) / 5
			body.get_node("Door").rotation_degrees += ($Carry/Door.rotation_degrees - body.get_node("Door").rotation_degrees) / 5
			body.scale = $Carry/Door.scale
		else:
			body.linear_velocity = ($Carry/RigidBody.global_transform.origin - body.global_transform.origin) * 10
			body.angular_velocity /= 1.1
	motion += transform.basis * get_movement() * speed * delta
	if is_on_floor():
		motion *= (1 - surface_friction)
	motion *= (1 - air_resistance)
	motion -= transform.basis.y * gravity * delta
	motion = move_and_slide(motion, transform.basis.y.normalized())
