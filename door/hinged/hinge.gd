tool
extends Spatial

export var hinge_position = Vector3(1.5, 3.25, -.125)

# warning-ignore:unused_argument
func _process(delta):
	if $AnimationPlayer.is_playing(): transform.origin = hinge_position - hinge_position.rotated(transform.basis.y, rotation_degrees.y / 180 * PI)
