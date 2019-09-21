extends Viewport

const mipmap_level = 0

func _ready():
	print(get_parent().exitDoorID)
	$Spatial/Camera.make_current()

func place_camera(exitDoor):
	size = (get_node("/root") as Viewport).size / pow(2, mipmap_level)
	$Spatial.global_transform = (get_node("/root/Main/ViewportContainer/PlayerViewport/Player/PivotY/PivotX/Camera") as Spatial).global_transform
	$Spatial.transform = get_parent().transform.inverse() * $Spatial.transform
	$Spatial.transform = $Spatial.transform.rotated(Vector3(0, 1, 0), PI)
	$Spatial.transform = exitDoor.transform * $Spatial.transform
	#$Spatial.translation -= get_parent().translation
	#$Spatial.transform = $Spatial.transform.rotated(get_parent().transform.basis.x, -get_parent().rotation_degrees.x / 180 * PI).rotated(get_parent().transform.basis.x, exitDoor.rotation_degrees.x / 180 * PI)
	#$Spatial.transform = $Spatial.transform.rotated(get_parent().transform.basis.y, -get_parent().rotation_degrees.y / 180 * PI).rotated(get_parent().transform.basis.y, exitDoor.rotation_degrees.y / 180 * PI)
	#$Spatial.transform = $Spatial.transform.rotated(get_parent().transform.basis.z, -get_parent().rotation_degrees.z / 180 * PI).rotated(get_parent().transform.basis.z, exitDoor.rotation_degrees.z / 180 * PI)
	#$Spatial.translation += exitDoor.translation
	#$Spatial.transform = $Spatial.transform.rotated(exitDoor.transform.basis.y, PI)

func _process(delta):
	place_camera(get_parent().get_parent().get_child(get_parent().exitDoorID))
	pass
