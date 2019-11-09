extends MeshInstance

export var hinge_position = Vector3(1.5, 3.25, -.125)

func _process(delta): transform.origin = hinge_position - hinge_position.rotated(transform.basis.y, rotation_degrees.y / 180 * PI)
