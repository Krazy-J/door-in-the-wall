extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 10.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if Input.is_action_pressed("move_forward"):
		print("onward!")
		# move as long as the key/button is pressed
		linear_velocity = Vector3(speed * delta, linear_velocity.y, 0)
	else:
		linear_velocity = Vector3(0, linear_velocity.y, 0)

