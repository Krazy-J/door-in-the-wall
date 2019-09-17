extends MeshInstance

export var exitDoorID = 0

func _on_DoorEnter_body_entered(body):
	if body.name == "Player":
		var exitDoor = get_parent().get_child(exitDoorID)
		body.transform = self.transform.inverse() * body.transform
		body.transform = body.transform.rotated(Vector3(0, 1, 0), PI)
		body.transform = exitDoor.transform * body.transform
