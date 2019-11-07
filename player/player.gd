extends KinematicBody

export var speed = 100
export var air_resistance = .01
export var surface_friction = .2
export var jump_power = 25
export var gravity = 80
export var mouse_sensitivity = .003 # radians/pixel
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

func get_movement():
	var movement = Vector3()
	if Input.is_action_pressed("move_forward"): movement.z -= 1
	if Input.is_action_pressed("move_back"): movement.z += 1
	if Input.is_action_pressed("move_left"): movement.x -= 1
	if Input.is_action_pressed("move_right"): movement.x += 1
	movement = movement.normalized()
	if Input.is_action_pressed("sprint"): movement *= 2
	if !is_on_floor(): movement /= 20
	return movement

func _physics_process(delta):
	motion += global_transform.basis * get_movement() * speed * delta
	if is_on_floor():
		if Input.is_action_just_pressed("jump"): motion += jump_power * transform.basis.y.normalized()
		motion *= (1 - surface_friction)
	motion *= (1 - air_resistance)
	motion -= gravity * delta * transform.basis.y.normalized()
	motion = move_and_slide(motion, transform.basis.y.normalized())
