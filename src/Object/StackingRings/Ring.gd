tool
extends "res://src/Object/RigidObject.gd"

export var radius : float = 2
export var size : float = 1
export var material : Material

func _ready():
	$Ring.inner_radius = radius
	$Ring.outer_radius = radius + size
	$Ring.material = material
	$Interact/Ring.inner_radius = $Ring.inner_radius - 0.1
	$Interact/Ring.outer_radius = radius + size + 0.1
	get_child(0).shape = get_child(0).shape.duplicate()
	get_child(0).shape.radius = size / 2.0  * 0.9
	get_child(0).shape.height = $Ring.outer_radius - size / 2.0
	for collision in range(6):
		get_child(collision).shape = get_child(0).shape
		get_child(collision).transform = Transform(Vector3(0,1,0),Vector3(-1,0,0),Vector3(0,0,1), Vector3(0, 0, radius * 0.85 + size * 0.45)).rotated(Vector3(0,-1,0), collision / 3.0 * PI)

func _process(_delta):
	if Engine.editor_hint: _ready()
	
