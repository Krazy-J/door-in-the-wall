tool
extends "res://gateway/gateway.gd"

export var start_enabled = false

func _ready():
	$Area.translation = Vector3(0, size.y / 2, -size.z / 2)
	$OuterArea.translation = $Area.translation
	$Area/Collision.shape.extents = size / 2 + Vector3(0, 0, -0.05)
	$OuterArea/Collision.shape.extents = size / 2
	$Area/Port.mesh.size = Vector2(size.x, size.y)
	if start_enabled: $Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	$Viewport/Spatial/Camera.make_current()

func place_camera():
	$Viewport/Spatial.global_transform = $"/root/Main/Player/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func disable_viewport(area):
	if area.get_parent().name == "Player": $Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
func enable_viewport(area):
	if area.get_parent().name == "Player": $Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS

func _process(_delta):
	if not Engine.editor_hint: place_camera()
