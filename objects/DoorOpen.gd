extends MeshInstance

var open = false
var selected = false

func toggle_door():
	open = !open
	var door = String(get_parent().exitDoorID % 2)
	if open:
		return get_node("AnimationPlayer").play("DoorOpen" + door)
	else:
		return get_node("AnimationPlayer").play_backwards("DoorOpen" + door)

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
