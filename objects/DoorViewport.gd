extends Viewport

func _ready():
	$Spatial/Camera.make_current()
	#$DoorCamera.global_transform.origin = Vector3(0, 1, 0)
	#world = (get_node("/root") as Viewport).world
	#own_world = true
	print("camera activated")