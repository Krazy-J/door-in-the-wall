extends KinematicBody

export var speed = 100
export var jump_power = 25
export var air_resistance = .01
export var surface_friction = .2
export var gravity = 80
export var carrying : NodePath
export var carry_distance : float
export var motion : Vector3

func _ready():
	if not has_node("../LobbyDoor"): $Pause/List/QuitLevel.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event.is_action_pressed("exit_mouse"): $Pause.popup()
	if is_on_floor():
		if event.is_action("jump"): motion += transform.basis.y * jump_power

func get_movement():
	var movement : Vector3
	if Input.is_key_pressed(KEY_W): movement.z -= 1
	if Input.is_key_pressed(KEY_S): movement.z += 1
	if Input.is_key_pressed(KEY_A): movement.x -= 1
	if Input.is_key_pressed(KEY_D): movement.x += 1
	if Input.is_key_pressed(KEY_SHIFT): movement *= 2
	if !is_on_floor(): movement /= 20
	return movement

func _process(_delta):
	if name == "Player2" and not get_parent().has_node("Player"): name = "Player"

func _physics_process(delta):
	motion += transform.basis * get_movement() * speed * delta
	if is_on_floor():
		motion *= (1 - surface_friction)
	transform.basis.x
	motion *= (1 - air_resistance)
	motion -= transform.basis.y * gravity * delta
	motion = move_and_slide(motion, transform.basis.y.normalized())

func _on_pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _on_unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_level():
	get_node("../LobbyDoor").toggle_door()
func _on_quit():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main.tscn")
	$"/root".call_deferred("add_child", load("res://interface/Fade.tscn").instance())
