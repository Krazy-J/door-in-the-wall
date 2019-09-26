extends Spatial

const mipmap_level = 1
var enteredDoor = false

func _ready():
	print(get_parent().exitDoorName)
	$Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	var exitDoor = get_node("../../" + get_parent().exitDoorName)
	body.transform = get_parent().transform.inverse() * body.transform
	body.motion = get_parent().global_transform.basis.inverse() * body.motion
	body.transform = exitDoor.transform * body.transform
	body.motion = exitDoor.global_transform.basis * body.motion

func place_camera(exitDoor):
	$Viewport.size = (get_node("/root") as Viewport).size / pow(2, mipmap_level)
	$Viewport/Spatial.global_transform = (get_node("/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera") as Spatial).global_transform
	$Viewport/Spatial.transform = get_parent().transform.inverse() * $Viewport/Spatial.transform
	$Viewport/Spatial.transform = exitDoor.transform * $Viewport/Spatial.transform

func _process(delta):
	place_camera(get_node("../../" + get_parent().exitDoorName))


func _on_EnterFront_body_entered(body):
	if body.name == "Player":
		if $ViewportBack.visible:
			$ViewportFront.visible = false
		else:
			enteredDoor = true

func _on_EnterBack_body_entered(body):
	if body.name == "Player":
		if $ViewportFront.visible:
			$ViewportBack.visible = false
		else:
			enteredDoor = true

func _on_EnterFront_body_exited(body):
	if body.name == "Player":
		if enteredDoor:
			teleport(body)
			enteredDoor = false
		$ViewportFront.visible = true

func _on_EnterBack_body_exited(body):
	if body.name == "Player":
		if enteredDoor:
			teleport(body)
			enteredDoor = false
		$ViewportBack.visible = true
