extends Spatial

const MIPMAP_LEVEL = 1
var entering_areas = {}
onready var exit_door = get_parent().get_node(get_parent().exit_door)

func _ready():
	$Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	var old_scale = body.scale
	body.global_transform = global_transform.affine_inverse() * body.global_transform
	body.global_transform = exit_door.global_transform * body.global_transform
	var relative_scale = body.scale.y / old_scale.y
	if body.name == "Player":
		body.motion = global_transform.basis.inverse() * body.motion
		body.motion = exit_door.global_transform.basis * body.motion
		if body.carrying:
			var carried_body = get_node(body.carrying)
			if carried_body.has_node("Door"):
				carried_body.global_transform = global_transform.affine_inverse() * carried_body.global_transform
				carried_body.global_transform = exit_door.global_transform * carried_body.global_transform
			else:
				body.carry_distance *= relative_scale
				for child in carried_body.get_children():
					child.scale *= relative_scale
					if child.name == "CollisionShape":
						child.shape = child.shape
						carried_body.mass *= relative_scale

func place_camera():
	$Viewport.size = $"/root".size / pow(2, MIPMAP_LEVEL)
	$Viewport/Spatial.global_transform = $"/root/Main/Player/PivotX/Camera".global_transform
	$Viewport/Spatial/Camera.near = abs(($Viewport/Spatial.global_transform.origin - global_transform.origin).rotated(Vector3(0, 1, 0), -$Viewport/Spatial.rotation_degrees.y / 180 * PI).z)
	teleport($Viewport/Spatial)

func _on_EnterFront_area_entered(area):
	if !entering_areas.has(area):
		if area.get_parent().name == "Player": $EnterFront.visible = false
		entering_areas[area] = "front"
	elif entering_areas[area] == "back":
		if area.get_parent().name == "Player": exit_door.get_node("Connection/EnterFront").visible = false
		teleport(area.get_parent())

func _on_EnterBack_area_entered(area):
	if !entering_areas.has(area):
		if area.get_parent().name == "Player": $EnterBack.visible = false
		entering_areas[area] = "back"
	elif entering_areas[area] == "front":
		if area.get_parent().name == "Player": exit_door.get_node("Connection/EnterBack").visible = false
		teleport(area.get_parent())

func _on_Middle_area_exited(area):
	entering_areas.erase(area)
	$EnterFront.visible = true
	$EnterBack.visible = true

func _process(delta):
	place_camera()
