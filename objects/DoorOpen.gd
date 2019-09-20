extends StaticBody

var open = false

func _ready():
	if open:
		get_node("AnimationPlayer").play("DoorOpen")
	else:
		get_node("AnimationPlayer").play_backwards("DoorOpen")
