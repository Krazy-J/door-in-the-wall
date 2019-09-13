extends Area

export var exitDoorPosition = Vector3()
export var exitDoorRotation = 0.0

func _on_DoorEnter_body_entered(body):
	if body.name == "Player":
		body.transform.origin += exitDoorPosition
		body.transform = body.transform.rotated(Vector3(0, 1, 0), exitDoorRotation*PI)
