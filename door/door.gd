tool
extends Spatial

export(PackedScene) var door
export(Mesh) var door_mesh
export(Material) var door_material
export var open = false
export var locked = false
var is_open = open

func _ready():
	if door: add_door()

func add_door(source = self):
	add_child(source.door.instance())
	if source.door_mesh: $Door.mesh = source.door_mesh
	if source.door_material: $Door.material_override = source.door_material.duplicate()

func toggle_door():
	if locked:
		$Door/AnimationPlayer.play("locked")
	else:
		open = not open
		if open:
			$Door/AnimationPlayer.play("door_toggle")
			$Door/SoundClose.stop()
			$Door/SoundOpen.play($Door/AnimationPlayer.current_animation_position)
		else:
			$Door/AnimationPlayer.play_backwards("door_toggle")
			$Door/SoundOpen.stop()
			$Door/SoundClose.play(1 - $Door/AnimationPlayer.current_animation_position)

func unlock():
	$Door.add_child(load("res://object/Key.tscn").instance())
	$Door/Key/Interact.queue_free()
	$Door/Key.set_script(null)
	$Door/AnimationPlayer.play("unlock")

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $Interact.valid or has_node("Door") and $Door/Interact.valid:
			if has_node("Door"):
				if locked and $"/root/Main/Player".carrying and get_node($"/root/Main/Player".carrying).name == "Key":
					get_node($"/root/Main/Player".carrying).queue_free()
					unlock()
				else: toggle_door()
			elif $"/root/Main/Player".carrying and get_node($"/root/Main/Player".carrying).has_node("Door"):
				add_door(get_node($"/root/Main/Player".carrying))
				get_node($"/root/Main/Player".carrying).queue_free()

func _process(_delta):
	if Engine.editor_hint:
		if has_node("Door"):
			if not door: $Door.queue_free()
			else:
				if not open == is_open:
					if open:
						$Door/AnimationPlayer.play("door_toggle")
						$Door/SoundOpen.play($Door/AnimationPlayer.current_animation_position)
					else:
						$Door/AnimationPlayer.play_backwards("door_toggle")
						$Door/SoundClose.play(1 - $Door/AnimationPlayer.current_animation_position)
					is_open = open
				if door_material and not $Door.material_override == door_material: $Door.material_override = door_material.duplicate()
		elif door: add_child(door.instance())
	if has_node("Door") and $Interact.visible and $Door/AnimationPlayer.current_animation == "unlock":
		$Interact._on_Interact_area_entered($"/root/Main/Player/PivotX/InteractArea")
