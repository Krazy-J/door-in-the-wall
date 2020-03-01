extends Node

func _on_start_body_exited(body):
	if body.name == "Player":
		for room in get_children():
			for door in room.get_node("Doors").get_children():
				if door.open: door.toggle_door()
				door.locked = false
