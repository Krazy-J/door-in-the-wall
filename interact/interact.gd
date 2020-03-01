extends Area

var valid

func _on_Interact_area_entered(area):
	if area.name == "InteractArea" and area.get_parent().get_parent().name == "Player":
		visible = true
		if not get_parent().get("locked") and $"/root/Main/Player".scale.y * 2 >= (global_transform.orthonormalized() * global_transform).basis.y.y:
			$Outline.material_override = load("res://interact/yellow.tres")
			valid = true
		else:
			$Outline.material_override = load("res://interact/red.tres")
			valid = false

func _on_Interact_area_exited(area):
	if area.name == "InteractArea":
		visible = false
		valid = false
