tool
extends "res://object/rigid_object.gd"

export var material : Material

func _ready():
	$Block.material = material

func _process(_delta):
	if Engine.editor_hint: _ready()
