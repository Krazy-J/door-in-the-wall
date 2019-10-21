extends Spatial

const mipmap_level = 1
var enteredDoor = false
var justExited = false
var passedThrough = false
var enteringBody
onready var exitDoor = get_node("../../" + get_parent().exitDoorName)

func _ready():
	$Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func teleport(body):
	body.transform = get_parent().transform.inverse() * body.transform
	body.motion = get_parent().global_transform.basis.inverse() * body.motion
	body.transform = exitDoor.transform * body.transform
	body.motion = exitDoor.global_transform.basis * body.motion

func place_camera():
	$Viewport.size = get_node("/root").size / pow(2, mipmap_level)
	$Viewport/Spatial.global_transform = get_node("/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera").global_transform
	$Viewport/Spatial.transform = get_parent().transform.inverse() * $Viewport/Spatial.transform
	$Viewport/Spatial.transform = exitDoor.transform * $Viewport/Spatial.transform

func _process(delta):
	place_camera()
	if justExited:
		if enteredDoor and passedThrough:
			if !$ViewportFront.visible: exitDoor.get_node("Connection/ViewportBack").visible = false
			if !$ViewportBack.visible: exitDoor.get_node("Connection/ViewportFront").visible = false
			teleport(enteringBody)
		if !enteredDoor or passedThrough:
			$ViewportFront.visible = true
			$ViewportBack.visible = true
		enteredDoor = false
		passedThrough = false
		justExited = false

func _on_EnterFront_body_entered(body):
	if body.name == "Player":
		if $ViewportBack.visible: $ViewportFront.visible = false
		else: enteredDoor = true

func _on_EnterBack_body_entered(body):
	if body.name == "Player":
		if $ViewportFront.visible: $ViewportBack.visible = false
		else: enteredDoor = true

func _on_EnterFront_body_exited(body):
	if body.name == "Player":
		enteringBody = body
		justExited = true
		if !$ViewportFront.visible: passedThrough = true

func _on_EnterBack_body_exited(body):
	if body.name == "Player":
		enteringBody = body
		justExited = true
		if !$ViewportBack.visible: passedThrough = true
