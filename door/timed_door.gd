tool
extends "res://door/door.gd"

export var close_timer : float = 5
var timer : float

func toggle_door():
	open = not open
	if open:
		timer = close_timer
		$Door/AnimationPlayer.play("DoorToggle")
		$Door/SoundClose.stop()
		$Door/SoundOpen.play($Door/AnimationPlayer.current_animation_position)
	else:
		$Door/AnimationPlayer.play_backwards("DoorToggle")
		$Door/SoundOpen.stop()
		$Door/SoundClose.play(1 - $Door/AnimationPlayer.current_animation_position)

func _process(delta):
	if open: timer -= delta
	if open and timer < 0: toggle_door()
