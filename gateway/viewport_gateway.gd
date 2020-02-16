tool
extends "res://gateway/gateway.gd"

export var start_enabled = false

func _ready():
	$Area/Port.mesh.size = Vector2(size.x, size.y)
	if start_enabled: $Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	$Viewport/Spatial/Camera.make_current()
	$Viewport.size = get_viewport().size
	$Viewport.shadow_atlas_size = get_viewport().shadow_atlas_size

func place_camera():
	$Viewport/Spatial.global_transform = $"/root/Main/Player/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func disable_viewport(area):
	if area.get_parent().name == "Player": $Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
func enable_viewport(area):
	if area.get_parent().name == "Player": $Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS

func _process(_delta):
	if not Engine.editor_hint: place_camera()
