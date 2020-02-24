extends Area

var interact

func _on_Interact_area_entered(area):
	if area.name == "InteractArea":
		visible = true
		if $"/root/Main/Player".scale.y >= (global_transform.orthonormalized() * global_transform).basis.y.y:
			$Outline.material_override = load("res://interact/yellow.tres")
			interact = true
		else:
			$Outline.material_override = load("res://interact/red.tres")
			interact = false

func _on_Interact_area_exited(area):
	if area.name == "InteractArea":
		visible = false
		interact = false
