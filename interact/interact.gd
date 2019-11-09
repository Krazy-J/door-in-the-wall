extends Area

func _on_Interact_area_entered(area):
	if area.name == "InteractArea": visible = true

func _on_Interact_area_exited(area):
	if area.name == "InteractArea": visible = false
