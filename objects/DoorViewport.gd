extends Viewport

onready var exitDoorID = get_parent().exitDoorID
onready var exitDoor = get_parent().get_parent().get_child(exitDoorID)

onready var player = get_node("/root/Spatial/Player")
onready var camera = $Spatial/Camera

func _ready():
	print(exitDoorID)
	camera.make_current()
	

func place_camera():
	#$Spatial/Camera.translation -= get_parent().translation
	camera.transform = Transform(Basis(), (player as Spatial).transform.origin);
	camera.translation -= get_parent().translation
	camera.transform = camera.transform.rotated(Vector3(1, 0, 0), (exitDoor.rotation_degrees.x - get_parent().rotation_degrees.x) / 180 * PI)
	camera.transform = camera.transform.rotated(Vector3(0, 1, 0), (exitDoor.rotation_degrees.y - get_parent().rotation_degrees.y) / 180 * PI)
	camera.transform = camera.transform.rotated(Vector3(0, 0, 1), (exitDoor.rotation_degrees.z - get_parent().rotation_degrees.z) / 180 * PI)
	camera.translation += exitDoor.translation

func _process(delta):
	place_camera()
	pass