tool
extends Spatial

export var door : PackedScene
export var door_mesh : Mesh
export var door_material : Material

func _ready():
	add_child(door.instance())
	if door_mesh: $Door.mesh = door_mesh
	$Door.material_override = door_material

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $Door/Interact.visible and !$"/root/Main/Player".carrying:
			$"/root/Main/Player".carrying = get_path()
			$AnimationPlayer.stop()
		elif $"/root/Main/Player".carrying == get_path():
			$"/root/Main/Player".carrying = NodePath()
			$AnimationPlayer.play("drop")

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not door_material == $Door.material_override: $Door.material_override = door_material
		elif door: add_child(door.instance())
