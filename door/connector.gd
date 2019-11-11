extends Spatial

const MIPMAP_LEVEL = 0
var entering_areas = {}
onready var exit_door = get_parent().get_node(get_parent().exit_door)

func _ready():
	$Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	body.global_transform = global_transform.affine_inverse() * body.global_transform
	body.global_transform = exit_door.global_transform * body.global_transform
	if body.name == "Player":
		body.motion = global_transform.basis.inverse() * body.motion
		body.motion = exit_door.global_transform.basis * body.motion
		if body.carrying:
			var body_carried = get_node(body.carrying)
			if body_carried.has_node("Door"):
				body_carried.global_transform = global_transform.affine_inverse() * body_carried.global_transform
				body_carried.global_transform = exit_door.global_transform * body_carried.global_transform
			else:
				for child in body_carried.get_children():
					child.global_transform.basis = global_transform.affine_inverse().basis * child.global_transform.basis
					child.global_transform.basis = exit_door.global_transform.basis * child.global_transform.basis
					if child.name == "CollisionShape":
						body_carried.gravity_scale = child.scale.x
						body_carried.mass = child.scale.x
						child.shape = child.shape

func place_camera():
	$Viewport.size = $"/root".size / pow(2, MIPMAP_LEVEL)
	$Viewport/Spatial.global_transform = $"/root/Player/PivotX/Camera".global_transform
	#$Viewport/Spatial.global_transform = $"/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func _on_EnterFront_area_entered(area):
	if area.name == "TeleportArea":
		if !entering_areas.has(area):
			if area.get_parent().name == "Player": $EnterFront.visible = false
			entering_areas[area] = "front"
		elif entering_areas[area] == "back":
			if area.get_parent().name == "Player": exit_door.get_node("Connection/EnterFront").visible = false
			teleport(area.get_parent())

func _on_EnterBack_area_entered(area):
	if area.name == "TeleportArea":
		if !entering_areas.has(area):
			if area.get_parent().name == "Player": $EnterBack.visible = false
			entering_areas[area] = "back"
		elif entering_areas[area] == "front":
			if area.get_parent().name == "Player": exit_door.get_node("Connection/EnterBack").visible = false
			teleport(area.get_parent())

func _on_Middle_area_exited(area):
	if area.name == "TeleportArea":
		entering_areas.erase(area)
		$EnterFront.visible = true
		$EnterBack.visible = true

func _process(delta):
	place_camera()
