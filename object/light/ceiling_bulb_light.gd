tool
extends Node

export var on : bool = true setget set_on
export var omni_range : float = 25 setget set_omni_range
export var height : float = 0.8 setget set_height
export var bulb_radius : float = 0.4 setget set_bulb_radius
var model_quality

func set_model_quality(set_model_quality):
	model_quality = pow(2, set_model_quality)
	$Bar.sides = min(4 * model_quality, 16)
	$Bar/Top.sides = min(8 * model_quality, 64)
	$Bulb.radial_segments = min(8 * model_quality, 64)
	$Bulb.rings = min(4 * model_quality, 32)
	model_quality = set_model_quality

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
	$Bar.translation.y = - height / 2
	$Bar/Top.translation.y = - height / 2 - 0.05
	$Bulb.translation.y = - height - 0.05 - $Bulb.radius

func set_bulb_radius(set_bulb_radius):
	bulb_radius = set_bulb_radius
	$Bulb.radius = bulb_radius
	$Bulb.translation.y = $Bar.translation.y + $Bar/Top.translation.y - $Bulb.radius

func _process(_delta):
	if not model_quality == ProjectSettings.object_model_quality:
		set_model_quality(ProjectSettings.object_model_quality)
