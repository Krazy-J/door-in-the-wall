tool
extends Spatial

const MIPMAP_LEVEL = 0
export var exit : NodePath
export var start_enabled = false
export var disable_gateways : Array
export var size = Vector3(2, 2, 0.4)

func _ready():
	if start_enabled: $Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	$Viewport/Spatial/Camera.make_current()
	$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	$OuterArea.translation = $Area.translation
	$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.05)
	$OuterArea/Collision.shape.extents = size / 2
	$Area/Port.mesh.size = Vector2(size.x, size.y)
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	body.global_transform = get_node(exit).global_transform * (global_transform.affine_inverse() * body.global_transform).rotated(Vector3(0, -1, 0), PI)
	if body.name == "Player": body.motion = get_node(exit).global_transform.basis * (global_transform.basis.inverse() * body.motion).rotated(Vector3(0, -1, 0), PI)

func place_camera():
	$Viewport.size = $"/root".size / pow(2, MIPMAP_LEVEL)
	$Viewport/Spatial.global_transform = $"/root/Main/Player/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func _on_outer_area_entered(area):
	if area.get_parent().name == "Player":
		get_node(exit).get_node("Viewport").render_target_update_mode = Viewport.UPDATE_ALWAYS

func _on_area_entered(area):
	if area.get_parent().name == "Player":
		$Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
		for gateway in disable_gateways: get_node(gateway).get_node("Viewport").render_target_update_mode = Viewport.UPDATE_DISABLED
		for gateway in get_node(exit).disable_gateways: get_node(exit).get_node(gateway).get_node("Viewport").render_target_update_mode = Viewport.UPDATE_ALWAYS
	teleport(area.get_parent())

func _process(delta):
	if Engine.editor_hint:
		$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
		$OuterArea.translation = $Area.translation
		$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.05)
		$OuterArea/Collision.shape.extents = size / 2
		$Area/Port.mesh.size = Vector2(size.x, size.y)
	else: place_camera()
