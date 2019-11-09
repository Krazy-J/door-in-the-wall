extends Spatial

func _on_Interact_area_entered(area):
	if area.name == "InteractArea": $Interact.visible = true

func _on_Interact_area_exited(area):
	if area.name == "InteractArea": $Interact.visible = false

func _input(event):
	if $Interact.visible and event.is_action_pressed("interact"):
		$"/root/Player/Hands".add_child(load("res://door/sliding/SlidingDoor.tscn").instance())
		$"/root/Player/Hands/Door".material_override = $Door.material_override
		queue_free()
