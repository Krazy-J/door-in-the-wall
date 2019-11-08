extends Spatial

const mipmap_level = 1
var in_door
onready var exit_door = get_parent().get_node(get_parent().exit_door)

func _ready():
	$Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	body.transform = get_parent().transform.affine_inverse() * body.transform
	body.transform = exit_door.transform * body.transform
	if body.name == "Player":
		body.motion = get_parent().global_transform.basis.inverse() * body.motion
		body.motion = exit_door.global_transform.basis * body.motion

func place_camera():
	$Viewport.size = $"/root".size / pow(2, mipmap_level)
	$Viewport/Spatial.global_transform = $"/root/Player/PivotX/Camera".global_transform
	#$Viewport/Spatial.global_transform = $"/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera".global_transform
	teleport($Viewport/Spatial)

func _on_EnterFront_area_entered(area):
	if area.name == "TeleportArea":
		if $EnterBack.visible: $EnterFront.visible = false
		else:
			exit_door.get_node("Connection/EnterFront").visible = false
			teleport(area.get_parent())

func _on_EnterBack_area_entered(area):
	if area.name == "TeleportArea":
		if $EnterFront.visible: $EnterBack.visible = false
		else:
			exit_door.get_node("Connection/EnterBack").visible = false
			teleport(area.get_parent())

func _on_Middle_area_exited(area):
	if area.name == "TeleportArea":
		$EnterFront.visible = true
		$EnterBack.visible = true

func _process(delta):
	place_camera()
