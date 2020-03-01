tool
extends "res://gateway/viewport_gateway.gd"

export var orthogonal = true

func teleport(body):
	body.global_transform = get_node(exit_path).global_transform
	body.global_transform.origin += get_node(exit_path).global_transform.basis * Vector3(0, 0, 5)
	if body.name == "Player":
		if get_node(exit_path).orthogonal == false:
			body.queue_free()
			$"/root/Main".add_child(load("res://player/UnOrthogonalPlayer.tscn").instance())
			body = $"/root/Main/Player2"
			body.global_transform = get_node(exit_path).global_transform
			body.global_transform.origin += get_node(exit_path).global_transform.basis * Vector3(0, 0, 2)
			body.rotation_degrees.y += 180
		elif orthogonal == false:
			body.queue_free()
			$"/root/Main".add_child(load("res://player/OrthogonalPlayer.tscn").instance())
			body = $"/root/Main/Player2"
			body.global_transform.origin = get_node(exit_path).global_transform.origin + get_node(exit_path).global_transform.basis * Vector3(0, 0, 2)

func place_camera():
	$Viewport.shadow_atlas_size = get_viewport().shadow_atlas_size
	teleport($Viewport/Spatial)
