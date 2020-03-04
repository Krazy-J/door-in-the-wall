tool
extends "res://door/gateway_door.gd"

export var section = 0
export(String, MULTILINE) var label setget set_label
export var label_color : Color setget set_label_color
var section_settings

func set_label(set_label):
	label = set_label
	$Label.text = label

func set_label_color(set_label_color):
	label_color = set_label_color
	$Label.color = label_color

func _ready():
	if not Engine.editor_hint and door:
		section_settings = ProjectSettings.levels[section][0]
		if section_settings.locked:
			material_override = load("res://object/plastic/red.tres")
			locked = true
			$Label2.text = str(ProjectSettings.completed_levels) + "/" + str(section_settings.requirement)
			if ProjectSettings.completed_levels >= section_settings.requirement:
				$Label2.color = Color(0,1,0)
		elif section_settings.completed:
			material_override = load("res://object/plastic/yellow.tres")

func toggle_door():
	if locked and not $Door/AnimationPlayer.is_playing():
		if ProjectSettings.completed_levels >= section_settings.requirement:
			$Door/AnimationPlayer.play("unlock")
			$Label2.queue_free()
		else: $Door/AnimationPlayer.play("locked")
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
