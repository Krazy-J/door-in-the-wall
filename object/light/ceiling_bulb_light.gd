tool
extends Node

export var on : bool = true setget set_on
export var omni_range : float = 25 setget set_omni_range
export var bar_height : float = 0.8 setget set_bar_height

func _ready():
	pass

func set_on(set_on):
	on = set_on
	$Top/Bulb/Light.shadow_enabled = on
	if on: $Top/Bulb.material_override = null
	else: $Top/Bulb.material_override = load("res://object/bulb_off.tres")
	set_omni_range(omni_range)

func set_omni_range(set_omni_range):
	omni_range = set_omni_range
	if on: $Top/Bulb/Light.omni_range = omni_range
	else: $Top/Bulb/Light.omni_range = 0

func set_bar_height(set_bar_height):
	bar_height = set_bar_height
	$Bar.height = bar_height
	$Bar.translation.y = -bar_height / 2
	$Top.translation.y = -(bar_height + 0.05)
