tool
extends "res://src/Gateway/Gateway.gd"

export var start_enabled : bool
export var stay_enabled : bool
export var is_door : bool

func _ready():
	$Area/Port.translation.z = -size.z / 2
	$Area/Port.mesh.size = Vector2(size.x, size.y)
	$Viewport.size = get_viewport().size
	$Viewport.shadow_atlas_size = get_viewport().shadow_atlas_size
	$Viewport/Spatial/Camera.make_current()
	if start_enabled and not Engine.editor_hint: enable_viewport()

func place_camera():
	$Viewport/Spatial.global_transform = $"/root/Main/Player/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func disable_viewport(area = $"/root/Main/Player/TeleportArea"):
	if not stay_enabled and area.get_parent().name == "Player":
		$Viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
func enable_viewport(area = $"/root/Main/Player/TeleportArea"):
	if area.get_parent().name == "Player":
		$Viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS

func _process(_delta):
	$Viewport/Spatial/Camera.fov = ProjectSettings.fov
	if is_door: $Viewport.shadow_atlas_size = ProjectSettings.door_shadow_atlas_size
	else: $Viewport.shadow_atlas_size = get_viewport().shadow_atlas_size
	if not Viewport.UPDATE_DISABLED and not Engine.editor_hint: place_camera()
