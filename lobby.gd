extends Spatial

func _ready():
	get_node("/root").call_deferred("add_child", load("res://player/Player.tscn").instance())
