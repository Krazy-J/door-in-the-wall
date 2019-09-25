extends Spatial

const mipmap_level = 1
const enteredDoor = 1

func _ready():
	print(get_parent().exitDoorName)
	$Viewport/Spatial/Camera.make_current()
	#var shaderMat = (($DoorViewport as GeometryInstance).material_override as ShaderMaterial) # Supposed to fix missing viewports. Welp, I tried.
	#if shaderMat.get_shader_param("Viewport") == null:
		#shaderMat.set_shader_param("Viewport", $DoorViewport/Viewport.get_texture())
		#print((shaderMat.get_shader_param("Viewport") as ViewportTexture).get_viewport_path_in_scene())

func _on_DoorEnter_area_entered(area):
	if area.name == "EnterPoint":
		var exitDoor = get_node("../../" + get_parent().exitDoorName)
		area.transform = get_parent().transform.inverse() * area.transform
		area.motion = get_parent().global_transform.basis.inverse() * area.motion
		area.transform = exitDoor.transform * area.transform
		area.motion = exitDoor.global_transform.basis * area.motion

func place_camera(exitDoor):
	$Viewport.size = (get_node("/root") as Viewport).size / pow(2, mipmap_level)
	$Viewport/Spatial.global_transform = (get_node("/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera") as Spatial).global_transform
	$Viewport/Spatial.transform = get_parent().transform.inverse() * $Viewport/Spatial.transform
	$Viewport/Spatial.transform = exitDoor.transform * $Viewport/Spatial.transform

func _process(delta):
	place_camera(get_node("../../" + get_parent().exitDoorName))
	pass


func _on_EnterFront_body_entered(body):
	pass # Replace with function body.


func _on_EnterFront_body_exited(body):
	pass # Replace with function body.


func _on_EnterBack_body_entered(body):
	pass # Replace with function body.


func _on_EnterBack_body_exited(body):
	pass # Replace with function body.
