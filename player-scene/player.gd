extends RigidBody


export var speed = 100.0;

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_forward"):
		linear_velocity = Vector3(linear_velocity.x, linear_velocity.y, -speed * delta)
	elif Input.is_action_pressed("move_back"):
		linear_velocity = Vector3(linear_velocity.x, linear_velocity.y, +speed * delta)
	else:
		linear_velocity = Vector3(linear_velocity.x, linear_velocity.y, 0)
		
	if Input.is_action_pressed("move_left"):
		linear_velocity = Vector3(-speed * delta, linear_velocity.y, linear_velocity.z)
	elif Input.is_action_pressed("move_right"):
		linear_velocity = Vector3(speed * delta, linear_velocity.y, linear_velocity.z)
	else:
		linear_velocity = Vector3(0, linear_velocity.y, linear_velocity.z)

