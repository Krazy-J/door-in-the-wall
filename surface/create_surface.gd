tool
extends CSGMesh

export var size = Vector2(2, 2)
export var create = false

# warning-ignore:unused_argument
func _process(delta):
	mesh = PlaneMesh.new()
	mesh.size = size
	if create:
		mesh.material = material
		mesh.material.uv1_scale.x *= size.x
		mesh.material.uv1_scale.y *= size.y
		create = false
		set_script(null)


