tool
extends Spatial

export var exit : NodePath
export var size = Vector3(2, 2, 0.4)

func _ready():
	$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	$OuterArea.translation = $Area.translation
	$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.05)
	$OuterArea/Collision.shape.extents = size / 2
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	body.global_transform = get_node(exit).global_transform * (global_transform.affine_inverse() * body.global_transform).rotated(Vector3(0, -1, 0), PI)
	if body.name == "Player": body.motion = get_node(exit).global_transform.basis * (global_transform.basis.inverse() * body.motion).rotated(Vector3(0, -1, 0), PI)

func _on_outer_area_entered(area):
	if get_node(exit).has_node("Viewport"): get_node(exit).enable_viewport(area)

func _on_area_entered(area):
	teleport(area.get_parent())

func _process(_delta):
	if Engine.editor_hint:
		$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
		$OuterArea.translation = $Area.translation
		$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.05)
		$OuterArea/Collision.shape.extents = size / 2
