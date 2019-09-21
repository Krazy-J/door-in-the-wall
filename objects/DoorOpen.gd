extends MeshInstance

var open = false
var selected = false

func toggle_door():
	open = !open
	if open:
		if get_parent().exitDoorID % 2:
			return get_node("AnimationPlayer").play("DoorOpen0")
		else:
			return get_node("AnimationPlayer").play("DoorOpen1")
	else:
		if get_parent().exitDoorID % 2:
			return get_node("AnimationPlayer").play_backwards("DoorOpen0")
		else:
			return get_node("AnimationPlayer").play_backwards("DoorOpen1")

func _on_Door_area_entered(area):
	if area.name == "InteractArea":
		selected = true

func _on_Door_area_exited(area):
	if area.name == "InteractArea":
		selected = false

func _process(delta):
	if selected and Input.is_action_just_pressed("interact"):
		toggle_door()
		get_parent().get_parent().get_child(get_parent().exitDoorID).get_child(5).toggle_door()
