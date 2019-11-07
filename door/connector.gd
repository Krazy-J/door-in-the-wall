extends Spatial

const mipmap_level = 1
var entered_door
var just_exited
var passed_through
var entering_body
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

func _process(delta):
	place_camera()
	if just_exited:
		if entered_door and passed_through:
			if !$ViewportFront.visible: exit_door.get_node("Connection/ViewportBack").visible = false
			if !$ViewportBack.visible: exit_door.get_node("Connection/ViewportFront").visible = false
			teleport(entering_body)
		if !entered_door or passed_through:
			$ViewportFront.visible = true
			$ViewportBack.visible = true
		entered_door = false
		passed_through = false
		just_exited = false

func _on_EnterFront_body_entered(body):
	if body.name == "Player":
		if $ViewportBack.visible: $ViewportFront.visible = false
		else: entered_door = true

func _on_EnterBack_body_entered(body):
	if body.name == "Player":
		if $ViewportFront.visible: $ViewportBack.visible = false
		else: entered_door = true

func _on_EnterFront_body_exited(body):
	if body.name == "Player":
		entering_body = body
		just_exited = true
		if !$ViewportFront.visible: passed_through = true

func _on_EnterBack_body_exited(body):
	if body.name == "Player":
		entering_body = body
		just_exited = true
		if !$ViewportBack.visible: passed_through = true
