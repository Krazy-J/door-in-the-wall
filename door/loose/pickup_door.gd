tool
extends Spatial

export(PackedScene) var door
export(Mesh) var door_mesh
export(Material) var door_material

func _ready():
	add_child(door.instance())
	if door_mesh: $Door.mesh = door_mesh
	$Door.material_override = door_material

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			$AnimationPlayer.play("drop")
		elif $Door/Interact.interact and !$"/root/Main/Player".carrying:
			$"/root/Main/Player".carrying = get_path()
			$AnimationPlayer.stop()

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not door_material == $Door.material_override: $Door.material_override = door_material
		elif door: add_child(door.instance())
