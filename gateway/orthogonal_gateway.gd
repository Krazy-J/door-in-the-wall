tool
extends Spatial

export var exit : NodePath
export var size = Vector3(2, 2, 0.4)
export var start_enabled = false
export var orthogonal = true

func _ready():
	$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.05)
	$Area/Outer/Collision.shape.extents = size / 2
	$Area/Port.mesh.size = Vector2(size.x, size.y)
	if start_enabled: $Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	$Viewport/Spatial/Camera.make_current()
	$Viewport.size = get_viewport().size
	$Viewport.shadow_atlas_size = get_viewport().shadow_atlas_size
	$Viewport/Spatial.global_transform.origin = get_node(exit).global_transform.origin + Vector3(0, 0, 10)

func disable_viewport():
	$Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
func enable_viewport():
	$Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS

func _on_outer_area_entered():
	pass
func _on_area_entered(area):
	teleport(area.get_parent())

func teleport(body):
	if body.name == "Player":
		if get_node(exit).orthogonal == false:
			$"/root/Main/Player".queue_free()
			$"/root/Main".add_child(load("res://player/UnOrthogonalPlayer.tscn").instance())
			$"/root/Main/Player2".global_transform = get_node(exit).global_transform
			$"/root/Main/Player2".global_transform.origin += get_node(exit).global_transform.basis * Vector3(0, 0, 2)
			$"/root/Main/Player2".rotation_degrees.y += 180
		elif orthogonal == false:
			$"/root/Main/Player".queue_free()
			$"/root/Main".add_child(load("res://player/OrthogonalPlayer.tscn").instance())
			$"/root/Main/Player2".global_transform.origin = get_node(exit).global_transform.origin + get_node(exit).global_transform.basis * Vector3(0, 0, 2)
		else:
			$"/root/Main/Player".global_transform = get_node(exit).global_transform
			$"/root/Main/Player".global_transform.origin += get_node(exit).global_transform.basis * Vector3(0, 0, 5)
