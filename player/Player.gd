extends KinematicBody

export var speed = 100
export var jump_power = 20
export var gravity = 80
export var mouse_sensitivity = 0.003 # radians/pixel
var motion = Vector3()
var movement = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("mouse_0"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("exit_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func get_input():
	var input_dir = Vector3()
	var camera_g_basis = $PivotY.transform.basis
	if Input.is_action_pressed("move_forward"):
		input_dir -= camera_g_basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += camera_g_basis.z
	if Input.is_action_pressed("move_left"):
		input_dir -= camera_g_basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += camera_g_basis.x
	#input_dir = (input_dir - input_dir * Vector3(abs(transform.basis.y.x), abs(transform.basis.y.y), abs(transform.basis.y.z))).normalized()
	input_dir = Vector3(input_dir.x, 0, input_dir.z).normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$PivotY.rotate_y(-event.relative.x * mouse_sensitivity)
		# linear_velocity = linear_velocity.rotated(Vector3(0, 1, 0), -event.relative.x * mouse_sensitivity)
		$PivotY/PivotX.rotate_x(-event.relative.y * mouse_sensitivity)
		$PivotY/PivotX.rotation.x = clamp($PivotY/PivotX.rotation.x, -1.5, 1.5)

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and get_node("GroundRay").is_colliding():
		motion.y += jump_power
	else: if get_node("GroundRay").is_colliding():
		motion += get_input() * speed * delta
		if motion.y < 0:
			motion.y = 0
		motion /= 1.2
	else:
		motion += get_input() * speed * delta / 20
		motion.y -= gravity * delta
		motion /= 1.01
	movement = move_and_slide(global_transform.basis * motion, Vector3(0, -1, 0))
