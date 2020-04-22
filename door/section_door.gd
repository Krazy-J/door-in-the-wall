tool
extends "res://door/gateway_door.gd"

export var section_number = 0
export(String, MULTILINE) var label setget set_label
export var label_color : Color setget set_label_color
onready var section = ProjectSettings.levels[section_number]
var section_completed = 0
var total_completed = 0

func _ready():
	if not Engine.editor_hint and door:
		for section in ProjectSettings.levels:
			for level in section:
				if not level == section[0] and level.completed:
					total_completed += 1
					if section == ProjectSettings.levels[section_number]: section_completed += 1
		if section[0].locked:
			$Frame.material = load("res://object/plastic/red.tres")
			set_locked(true)
			$Label2.text = str(total_completed) + "/" + str(section[0].requirement)
			if total_completed >= section[0].requirement:
				$Label2.color = Color(0,1,0)
		elif section_completed == section.size() - 1:
			$Frame.material = load("res://object/medal/gold.tres")
			exit.get_node("Frame").material_override = load("res://object/medal/gold.tres")
		elif section_completed >= section.size() * .75 - 1:
			$Frame.material = load("res://object/silver.tres")
			exit.get_node("Frame").material_override = load("res://object/silver.tres")
		elif section_completed >= section.size() * .5 - 1:
			$Frame.material = load("res://object/bronze.tres")
			exit.get_node("Frame").material = load("res://object/bronze.tres")

func set_label(set_label):
	label = set_label
	$Label.text = label

func set_label_color(set_label_color):
	label_color = set_label_color
	$Label.color = label_color

func toggle_door():
	if locked:
		if total_completed >= section[0].requirement:
			unlock()
			$Label2.queue_free()
			$Frame.material = null
			section[0].locked = false
		elif not $Door/AnimationPlayer.is_playing(): $Door/AnimationPlayer.play("locked")
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
