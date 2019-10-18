extends MeshInstance

export var exitDoorName = String()
export var open = false
var selected = false

func _ready():
	if open and $Door:
		$Door/AnimationPlayer.play("DoorToggle")
		$Door/AnimationPlayer.seek(1)

func toggle_door():
	open = !open
	if open:
		$Door/AnimationPlayer.play("DoorToggle")
		$Door/SoundOpen.play()
	else:
		$Door/AnimationPlayer.play_backwards("DoorToggle")
		$Door/SoundClose.play()

func _on_Interact_area_entered(area):
	if area.name == "InteractArea":
		selected = true

func _on_Interact_area_exited(area):
	if area.name == "InteractArea":
		selected = false

func _process(delta):
	if selected and Input.is_action_just_pressed("interact") and $Door:
		toggle_door()
		if $Connection:
			get_parent().get_node("./" + exitDoorName).toggle_door()
