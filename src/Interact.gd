extends Spatial

export var object_size : float = 1
var focused = false
var valid = false
var locked = false

func update_valid():
	valid = $"/root/Main/Player".scale.y * 2 >= (global_transform.orthonormalized() * global_transform).basis.y.y * object_size
	for child in get_children():
		if valid and not locked: child.material = load("res://assets/material/yellow.tres")
		else: child.material = load("res://assets/material/red.tres")
	if not focused: valid = false

func interact_entered():
	visible = true
	focused = true
	update_valid()

func interact_exited():
	visible = false
	focused = false
	valid = false
