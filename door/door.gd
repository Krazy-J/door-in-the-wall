tool
extends Spatial

export var door : PackedScene
export var door_mesh : Mesh
export var door_material : Material
export var open = false
var is_open = open

func _ready():
	if door:
		add_child(door.instance())
		if door_mesh: $Door.mesh = door_mesh
		if door_material: $Door.material_override = door_material.duplicate()

func toggle_door():
	open = not open
	if open:
		$Door/AnimationPlayer.play("DoorToggle")
		$Door/SoundClose.stop()
		$Door/SoundOpen.play($Door/AnimationPlayer.current_animation_position)
	else:
		$Door/AnimationPlayer.play_backwards("DoorToggle")
		$Door/SoundOpen.stop()
		$Door/SoundClose.play(1 - $Door/AnimationPlayer.current_animation_position)

func _unhandled_input(event):
	if event.is_action_pressed("interact") and ($Interact.visible or has_node("Door") and $Door/Interact.visible):
		if has_node("Door"): toggle_door()
		elif $"/root/Main/Player".carrying and get_node($"/root/Main/Player".carrying).has_node("Door"):
			add_child(get_node($"/root/Main/Player".carrying).door.instance())
			if door_mesh: $Door.mesh = get_node($"/root/Main/Player".carrying).door_mesh
			$Door.material_override = get_node($"/root/Main/Player".carrying).door_material.duplicate()
			get_node($"/root/Main/Player".carrying).queue_free()

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not door: $Door.queue_free()
			else:
				if not open == is_open:
					if open:
						$Door/AnimationPlayer.play("DoorToggle")
						$Door/SoundOpen.play()
					else:
						$Door/AnimationPlayer.play_backwards("DoorToggle")
						$Door/SoundClose.play()
					is_open = open
				if door_material and not $Door.material_override == door_material: $Door.material_override = door_material.duplicate()
		elif door: add_child(door.instance())
