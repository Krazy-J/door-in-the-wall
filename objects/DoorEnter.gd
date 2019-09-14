extends MeshInstance

export var exitDoorID = 0

func _on_DoorEnter_body_entered(body):
	if body.name == "Player":
		var exitDoor = get_parent().get_child(exitDoorID)
		body.translation -= translation
		body.transform = body.transform.rotated(Vector3(0, 0, 1), (exitDoor.rotation_degrees.x - rotation_degrees.x) / 180 * PI)
		body.transform = body.transform.rotated(Vector3(0, 1, 0), (180 + exitDoor.rotation_degrees.y - rotation_degrees.y) / 180 * PI)
		body.transform = body.transform.rotated(Vector3(1, 0, 0), (exitDoor.rotation_degrees.z - rotation_degrees.z) / 180 * PI)
		body.translation += exitDoor.translation
