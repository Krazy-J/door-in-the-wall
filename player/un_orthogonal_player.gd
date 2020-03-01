extends "res://player/player.gd"

func _process(_delta):
	if name == "Player2" and not get_parent().has_node("Player"): name = "Player"
