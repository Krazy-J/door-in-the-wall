extends MeshInstance

export var exitDoorName = String(0)
var open = false
var selected = false
var firstDoor = false
const mipmap_level = 1

func _ready():
	print(exitDoorName)
	$DoorViewport/Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func _on_DoorEnter_body_entered(body):
	if body.name == "Player":
		var exitDoor = get_parent().get_node("./" + exitDoorName)
		body.transform = self.transform.inverse() * body.transform
		body.transform = body.transform.rotated(Vector3(0, 1, 0), PI)
		body.transform = exitDoor.transform * body.transform
		body.motion = self.global_transform.basis.inverse() * body.motion
		body.motion = body.motion.rotated(Vector3(0, 1, 0), PI)
		body.motion = exitDoor.global_transform.basis * body.motion

func place_camera(exitDoor):
	$DoorViewport/Viewport.size = (get_node("/root") as Viewport).size / pow(2, mipmap_level)
	$DoorViewport/Viewport/Spatial.global_transform = (get_node("/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera") as Spatial).global_transform
	$DoorViewport/Viewport/Spatial.transform = self.transform.inverse() * $DoorViewport/Viewport/Spatial.transform
	$DoorViewport/Viewport/Spatial.transform = $DoorViewport/Viewport/Spatial.transform.rotated(Vector3(0, 1, 0), PI)
	$DoorViewport/Viewport/Spatial.transform = exitDoor.transform * $DoorViewport/Viewport/Spatial.transform

func toggle_door():
	open = !open
	if open:
		return $Door/AnimationPlayer.play("DoorToggle" + String(firstDoor))
	else:
		return $Door/AnimationPlayer.play_backwards("DoorToggle" + String(firstDoor))
	print(String(firstDoor))

func _on_Interact_area_entered(area):
	if area.name == "InteractArea":
		selected = true

func _on_Interact_area_exited(area):
	if area.name == "InteractArea":
		selected = false

func _process(delta):
	firstDoor = !get_parent().get_node("./" + exitDoorName).firstDoor
	if selected and Input.is_action_just_pressed("interact") and $Door:
		toggle_door()
		get_parent().get_node("./" + exitDoorName).toggle_door()
	place_camera(get_parent().get_node("./" + exitDoorName))
	pass
