extends Node

func _on_Begin_pressed():
	$AnimationPlayer.play("begin")

func load_scenes():
	$"/root".call_deferred("add_child", load("res://interface/Fade.tscn").instance())

func load_lobby():
	get_tree().change_scene("res://room/Lobby.tscn")

func _process(delta):
	$Spatial/Camera.rotation_degrees.y -= 2 * delta
