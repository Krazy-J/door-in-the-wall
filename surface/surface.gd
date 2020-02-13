tool
extends CSGMesh

func _ready():
	mesh.material = material
	material.uv1_scale.x *= mesh.size.x
	material.uv1_scale.y *= mesh.size.y
