extends Viewport

onready var camera = $Spatial/Camera

const mipmap_level = 0;

func _ready():
	print(get_parent().exitDoorID)
	$Spatial/Camera.make_current()

func place_camera(exitDoor):
	size = (get_node("/root") as Viewport).size / pow(2, mipmap_level)
	#$Spatial.translation = get_node("/root/Main/Player").translation
	$Spatial.global_transform = (get_node("/root/Main/Player/PivotY/PivotX/Camera") as Spatial).global_transform
	$Spatial.translation -= get_parent().translation
	$Spatial.transform = $Spatial.transform.rotated(Vector3(1, 0, 0), (-get_parent().rotation_degrees.x) / 180 * PI)
	$Spatial.transform = $Spatial.transform.rotated(Vector3(0, 1, 0), (-get_parent().rotation_degrees.y) / 180 * PI)
	$Spatial.transform = $Spatial.transform.rotated(Vector3(0, 0, 1), (-get_parent().rotation_degrees.z) / 180 * PI)
	$Spatial.transform = $Spatial.transform.rotated(Vector3(1, 0, 0), (exitDoor.rotation_degrees.x) / 180 * PI)
	$Spatial.transform = $Spatial.transform.rotated(Vector3(0, 1, 0), (exitDoor.rotation_degrees.y) / 180 * PI)
	$Spatial.transform = $Spatial.transform.rotated(Vector3(0, 0, 1), (exitDoor.rotation_degrees.z) / 180 * PI)
	$Spatial.transform = $Spatial.transform.rotated(exitDoor.transform.basis.y, (180) / 180 * PI)
	$Spatial.translation += exitDoor.translation

func _process(delta):
	place_camera(get_parent().get_parent().get_child(get_parent().exitDoorID))
	pass
