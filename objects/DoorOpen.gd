extends Area

var open = false
var selected = false

func toggle_door():
	if open:
		if self.exitDoorID % 2:
			get_node("AnimationPlayer").play_backwards("DoorOpen-")
		else:
			get_node("AnimationPlayer").play_backwards("DoorOpen+")
	else:
		if self.exitDoorID % 2:
			get_node("AnimationPlayer").play("DoorOpen-")
		else:
			get_node("AnimationPlayer").play("DoorOpen+")

func _on_Door_area_entered(area):
	if area.name == "InteractRay":
		selected = true

func _on_Door_area_exited(area):
	if area.name == "InteractRay":
		selected = false

func _process(delta):
	if selected and Input.is_action_just_pressed("interact"):
		get_parent().toggle_door()
		get_parent().get_parent().get_child(get_parent().exitDoorID).toggle_door()
