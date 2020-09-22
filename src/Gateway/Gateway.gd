tool extends Spatial

export var exit_path : NodePath
export var size = Vector3(2, 2, 0.4)

func _ready():
	$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.02)
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleported_basis(vector):
	return get_node(exit_path).global_transform.basis * (global_transform.basis.inverse() * vector).rotated(Vector3(0, -1, 0), PI)

func teleport(body):
	body.global_transform = get_node(exit_path).global_transform * (global_transform.affine_inverse() * body.global_transform).rotated(Vector3(0, -1, 0), PI)

func teleport_player(body):
	teleport(body)
	body.motion = teleported_basis(body.motion)
	if body.carrying:
		if body.carrying.has_node("Door"):
			body.carrying.global_transform = get_node(exit_path).global_transform * (global_transform.affine_inverse() * body.carrying.global_transform)
		elif body.carrying.is_class("RigidBody"):
			var relative_scale = (get_node(exit_path).global_transform.basis.get_scale() / global_transform.basis.get_scale()).y
			body.carry_distance *= relative_scale
			teleport_rigidbody(body.carrying)
			#body.carrying.mass *= relative_scale

func teleport_rigidbody(body):
	teleport(body)
	#body.mass *= relative_scale
	for child in body.get_children():
		child.scale *= 1
		child.translation *= 1
	body.linear_velocity = teleported_basis(body.linear_velocity)
	body.angular_velocity = teleported_basis(body.angular_velocity)

func _on_area_entered(area):
	if get_node(exit_path).has_node("Viewport"): get_node(exit_path).enable_viewport(area)
	if area.get_parent().name == "Player": teleport_player(area.get_parent())
	elif area.get_parent().is_class("RigidBody"):
		 if not area.get_parent().carrying: teleport_rigidbody(area.get_parent())
	else: teleport(area.get_parent())

func _process(_delta):
	if Engine.editor_hint: _ready()
