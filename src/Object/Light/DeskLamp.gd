tool
extends Node

export var on : bool = true setget set_on
export var omni_range : float = 25 setget set_omni_range
export var height : float = 0.8 setget set_height
var model_quality

func set_model_quality(set_model_quality):
	model_quality = pow(2, set_model_quality)
	$Base.sides = min(8 * model_quality, 64)
	$Base/Slant.sides = $Base.sides
	$Bar.sides = min(4 * model_quality, 32)
	$Screw.sides = min(4 * model_quality, 64)
	$Bulb.radial_segments = min(8 * model_quality, 32)
	$Bulb.rings = min(4 * model_quality, 16)
	model_quality = set_model_quality
	$Base/Slant.visible = model_quality >= 1
	$Screw.visible = model_quality >= 2
	$Shade/Crossbars.visible = model_quality >= 1

func set_on(set_on):
	on = set_on
	$Bulb.material = $Bulb.material.duplicate()
	$Bulb.material.flags_unshaded = on
	$Bulb/Light.visible = on

func set_omni_range(set_omni_range):
	omni_range = set_omni_range
	$Bulb/Light.omni_range = omni_range

func set_height(set_height):
	height = set_height
	$Bar.height = height
	$Bar.translation.y = height / 2 + 0.1
	$Screw.translation.y = height + 0.12
	$Bulb.translation.y = height + 0.2
	$Shade.translation.y = height + 0.2

func _process(_delta):
	if not model_quality == ProjectSettings.object_model_quality:
		set_model_quality(ProjectSettings.object_model_quality)
