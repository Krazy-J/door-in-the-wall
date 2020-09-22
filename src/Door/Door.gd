tool extends Spatial

export(PackedScene) var door setget set_door
export(Mesh) var door_mesh setget set_door_mesh
export(Material) var door_material setget set_door_material
export var open : bool = false setget set_open
export var locked : bool = false setget set_locked
var is_open = open

func set_door(set_door):
	door = set_door
	if door:
		add_child(door.instance())
		set_door_mesh(door_mesh)
		set_door_material(door_material)
		set_locked(locked)
	elif has_node("Door"): $Door.queue_free()

func set_door_mesh(set_door_mesh):
	door_mesh = set_door_mesh
	if door:
		if door_mesh: $Door.mesh = door_mesh
		else: $Door.mesh = door.instance().mesh

func set_door_material(set_door_material):
	door_material = set_door_material
	if door:
		if door_material: $Door.material = door_material.duplicate()
		else: $Door.material = null

func set_open(set_open):
	if door:
		if Engine.editor_hint and not is_open == set_open:
			open = not set_open
			toggle_door()
			is_open = set_open
		elif not $Door/AnimationPlayer.is_playing():
			open = set_open
			if open:
				$Door/AnimationPlayer.play("door_toggle")
				$Door/AnimationPlayer.seek($Door/AnimationPlayer.current_animation_length)
			else:
				$Door/AnimationPlayer.play_backwards("door_toggle")
				$Door/AnimationPlayer.seek(0)

func set_locked(set_locked):
	locked = set_locked
	if not Engine.editor_hint:
		$Frame/Interact.locked = locked
		if door: $Door/Body/Interact.locked = locked

func toggle_door():
	if locked:
		if not $Door/AnimationPlayer.is_playing(): $Door/AnimationPlayer.play("locked")
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
	$Door.add_child(load("res://src/Object/Key.tscn").instance())
	$Door/Key/Interact.queue_free()
	$Door/Key.set_script(null)
	$Door/AnimationPlayer.play("unlock")

func update_interact():
	if door:
		if not $Frame/Interact.focused:
			if $Door/Body/Interact.focused: $Frame/Interact.update_valid()
			$Frame/Interact.visible = $Door/Body/Interact.focused
		if not $Door/Body/Interact.focused:
			if $Frame/Interact.focused: $Door/Body/Interact.update_valid()
			$Door/Body/Interact.visible = $Frame/Interact.focused
		if $Frame/Interact.visible and $Door/AnimationPlayer.current_animation == "unlock":
			$Frame/Interact.update_valid()

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if $Frame/Interact.valid or door and $Door/Body/Interact.valid:
			if door:
				if locked and $"/root/Main/Player".carrying and $"/root/Main/Player".carrying.name == "Key":
					unlock()
					$"/root/Main/Player".carrying.queue_free()
					$"/root/Main/Player".carrying = null
				else: toggle_door()
			elif $"/root/Main/Player".carrying and $"/root/Main/Player".carrying.has_node("Door"):
				set_door($"/root/Main/Player".carrying.door)
				set_door_mesh($"/root/Main/Player".carrying.door_mesh)
				set_door_material($"/root/Main/Player".carrying.door_material)
				$"/root/Main/Player".carrying.queue_free()
				$"/root/Main/Player".carrying = null

func _process(_delta):
	if not Engine.editor_hint: update_interact()
