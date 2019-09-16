extends RigidBody

export var speed = 400
export var jump_power = 50000
var jump = 0
export var mouse_sensitivity = 0.003 # radians/pixel
export var gravity = 10000

onready var camera = $PivotY/PivotX/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("mouse_0"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("exit_mouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func get_input():
	var input_dir = Vector3()
	var camera_g_basis = camera.global_transform.basis
	if Input.is_action_pressed("move_forward"):
		input_dir -= camera_g_basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += camera_g_basis.z
	if Input.is_action_pressed("move_left"):
		input_dir -= camera_g_basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += camera_g_basis.x
	input_dir = (input_dir - input_dir * Vector3(abs(transform.basis.y.x), abs(transform.basis.y.y), abs(transform.basis.y.z))).normalized()
	
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$PivotY.rotate_y(-event.relative.x * mouse_sensitivity)
		# linear_velocity = linear_velocity.rotated(Vector3(0,1,0), -event.relative.x * mouse_sensitivity)
		$PivotY/PivotX.rotate_x(-event.relative.y * mouse_sensitivity)
		$PivotY/PivotX.rotation.x = clamp($PivotY/PivotX.rotation.x, -1.5, 1.5)

func _physics_process(delta):
	linear_velocity = get_input() * delta * speed
	add_central_force(-transform.basis.y * delta * gravity)
	if Input.is_action_just_pressed("jump"):
		jump = jump_power
	if jump > 0:
		add_central_force(transform.basis.y * delta * jump)
		jump -= 1000
	

