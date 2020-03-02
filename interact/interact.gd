extends Area

var valid

func _on_Interact_area_entered(area):
	if area.name == "InteractArea" and area.get_parent().get_parent().name == "Player":
		visible = true
		valid = $"/root/Main/Player".scale.y * 2 >= (global_transform.orthonormalized() * global_transform).basis.y.y
		if valid and not get_parent().get("locked"): $Outline.material_override = load("res://interact/yellow.tres")
		else: $Outline.material_override = load("res://interact/red.tres")

func _on_Interact_area_exited(area):
	if area.name == "InteractArea":
		visible = false
		valid = false
