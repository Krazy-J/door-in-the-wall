extends Area

var valid

func _on_Interact_area_entered(area):
	if area.name == "InteractArea":
		visible = true
		if $"/root/Main/Player".scale.y * 2 >= (global_transform.orthonormalized() * global_transform).basis.y.y and not get_parent().get("locked"):
			$Outline.material_override = load("res://interact/yellow.tres")
			valid = true
		else:
			$Outline.material_override = load("res://interact/red.tres")
			valid = false

func _on_Interact_area_exited(area):
	if area.name == "InteractArea":
		visible = false
		valid = false
