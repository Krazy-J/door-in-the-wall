extends MeshInstance


func _ready():
	var animation = $AnimationPlayer.get_animation("DoorToggle")
	var hinge_position = Vector3(.15, 0, 1.5)
	var radius = transform.origin.distance_to(hinge_position)
	var curve = 2 / (PI * radius)
	var curve_offset = 0
	var base_handle = [Vector2(0.2, 0), Vector2(-0.2, 0)]
	animation.bezier_track_set_key_out_handle(0, 0, base_handle[0])
	animation.bezier_track_set_key_in_handle(0, 1, base_handle[1])
	animation.bezier_track_set_key_in_handle(1, 1, Vector2(- curve + base_handle[1].x * (1 - curve), - curve_offset))
	animation.bezier_track_set_key_out_handle(2, 0, Vector2(curve + base_handle[0].x * (1 - curve), - curve_offset))
	animation.bezier_track_set_key_out_handle(1, 0, base_handle[0])
	animation.bezier_track_set_key_in_handle(2, 1, base_handle[1])
