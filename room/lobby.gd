extends Spatial

func _ready():
	if !$"/root".has_node("Player"):
		$"/root".call_deferred("add_child", load("res://player/Player.tscn").instance())
		$"/root".call_deferred("add_child", load("res://FadeSplash.tscn").instance())
