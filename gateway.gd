tool
extends Spatial

const MIPMAP_LEVEL = 0
export var connection : NodePath
onready var exit = get_node(connection)
export var size = Vector3(2, 2, 0.4)
var entering_areas = []

func _ready():
	$Viewport/Spatial/Camera.make_current()
	$Area/Collision.shape.extents = size / 2 - Vector3(0, 0, 0.05)
	$Area/Port.mesh.size = Vector2(size.x, size.y)
	$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	body.global_transform = exit.global_transform * (global_transform.affine_inverse() * body.global_transform).rotated(Vector3(0, -1, 0), PI)
	if body.name == "Player": body.motion = exit.global_transform.basis * (global_transform.basis.inverse() * body.motion).rotated(Vector3(0, -1, 0), PI)

func place_camera():
	$Viewport.size = $"/root".size / pow(2, MIPMAP_LEVEL)
	$Viewport/Spatial.global_transform = $"/root/Main/Player/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func _on_area_entered(area):
	teleport(area.get_parent())

func _process(delta):
	if Engine.editor_hint:
		$Area/Collision.shape.extents = size / 2 - Vector3(0, 0, 0.05)
		$Area/Port.mesh.size = Vector2(size.x, size.y)
		$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	else: place_camera()
