extends Spatial

var focused = false
var valid = false
var locked = false

func interact_entered():
	visible = true
	focused = true
	valid = $"/root/Main/Player".scale.y * 2 >= (global_transform.orthonormalized() * global_transform).basis.y.y
	for child in get_children():
		if valid and not locked: child.material_override = load("res://interact/yellow.tres")
		else: child.material_override = load("res://interact/red.tres")

func interact_exited():
	visible = false
	focused = false
	valid = false
