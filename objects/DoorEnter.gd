extends MeshInstance

export var exitDoorID = 0

func _on_DoorEnter_body_entered(body):
	if body.name == "Player":
		var exitDoor = get_parent().get_child(exitDoorID)
		body.translation -= translation
		body.transform = body.transform.rotated(transform.basis.x, (exitDoor.rotation_degrees.x - rotation_degrees.x) / 180 * PI)
		body.transform = body.transform.rotated(transform.basis.y, (exitDoor.rotation_degrees.y - rotation_degrees.y) / 180 * PI)
		body.transform = body.transform.rotated(transform.basis.z, (exitDoor.rotation_degrees.z - rotation_degrees.z) / 180 * PI)
		body.transform = body.transform.rotated(exitDoor.transform.basis.y, PI)
		body.translation += exitDoor.translation
