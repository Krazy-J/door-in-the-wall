extends Spatial

func _ready():
	$"/root".call_deferred("add_child", load("res://player/Player.tscn").instance())
