extends Node

export var door : NodePath

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$AnimationPlayer.play("opening")

func _input(event):
	if event.is_action_pressed("exit_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("left_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif has_node("CinematicBar2/Skip") and ($AnimationPlayer.current_animation_position > 2 or $AnimationPlayer.current_animation == "cinematic"):
				$AnimationPlayer.seek(7.99)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "opening":
		$AnimationPlayer.play("cinematic")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://Main.tscn")

func _process(delta):
	if $AnimationPlayer.current_animation == "cinematic": get_node(door).transform.origin = Vector3(1.5, 3.25, -.125) - Vector3(1.5, 3.25, -.125).rotated(get_node(door).transform.basis.y, get_node(door).rotation_degrees.y / 180 * PI)
