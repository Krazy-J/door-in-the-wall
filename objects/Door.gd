extends MeshInstance

export var exitDoorName = String()
export var firstDoor = true
export var open = false
var selected = false

func _ready():
	if !firstDoor and $Door:
		$Door.rotation_degrees.y = 180
	if open:
		$Door/AnimationPlayer.play("DoorToggle" + String(firstDoor))
		$Door/AnimationPlayer.seek(1)

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
	if selected and Input.is_action_just_pressed("interact") and $Door:
		toggle_door()
		if $DoorConnector:
			get_parent().get_node("./" + exitDoorName).toggle_door()
