extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func load_scenes():
	$"/root".call_deferred("add_child", load("res://interface/Fade.tscn").instance())
# warning-ignore:return_value_discarded
func load_lobby(): get_tree().change_scene("res://room/Lobby.tscn")

func quit_game(): get_tree().quit()

func _process(delta):
	$Spatial/Camera.rotation_degrees.y -= 2 * delta
