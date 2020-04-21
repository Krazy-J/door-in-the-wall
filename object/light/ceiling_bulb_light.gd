tool
extends Node

export var on : bool = true setget set_on
export var omni_range : float = 25 setget set_omni_range
export var bar_height : float = 0.8 setget set_bar_height
export var bulb_radius : float = 0.4 setget set_bulb_radius

func set_on(set_on):
	on = set_on
	$Bulb/Light.shadow_enabled = on
	$Bulb.material = $Bulb.material.duplicate()
	$Bulb.material.flags_unshaded = on
	set_omni_range(omni_range)

func set_omni_range(set_omni_range):
	omni_range = set_omni_range
	if on: $Bulb/Light.omni_range = omni_range
	else: $Bulb/Light.omni_range = 0

func set_bar_height(set_bar_height):
	bar_height = set_bar_height
	$Bar.height = bar_height
	$Bar.translation.y = - bar_height / 2
	$Bar/Top.translation.y = $Bar.translation.y - 0.05
	$Bulb.translation.y = $Bar.translation.y + $Bar/Top.translation.y - $Bulb.radius

func set_bulb_radius(set_bulb_radius):
	bulb_radius = set_bulb_radius
	$Bulb.radius = bulb_radius
	$Bulb.translation.y = $Bar.translation.y + $Bar/Top.translation.y - $Bulb.radius
