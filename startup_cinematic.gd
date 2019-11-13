extends Node

export var door : NodePath

func _ready():
	$AnimationPlayer.play("opening")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("exit_mouse"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("left_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif $Skip.visible: $AnimationPlayer.seek(7.99)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "opening":
		$AnimationPlayer.play("cinematic")
	else:
		get_tree().change_scene("res://Main.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta): get_node(door).transform.origin = Vector3(1.5, 3.25, -.125) - Vector3(1.5, 3.25, -.125).rotated(get_node(door).transform.basis.y, get_node(door).rotation_degrees.y / 180 * PI)
