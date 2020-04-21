tool
extends Node

var levels = [
	[
		{
			"locked": false,
			"scene": "Lobby"
		},
		{
			"completed": false,
			"locked": false,
			"scene": "TestRoom"
		},
		{
			"completed": false,
			"locked": false,
			"scene": "TheFunRoom"
		},
		{
			"completed": false,
			"locked": false,
			"scene": "Orthogonal"
		}
	],
	[
		{
			"locked": false,
			"requirement": 0
		},
		{
			"completed": false,
			"locked": false,
			"scene": "classic/1"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/2"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/_3Loop"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/_6Locked"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/_5Memory"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/_8BuildUp"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/_4ManyDoors"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "classic/_7Flipped"
		}
	],
	[
		{
			"locked": true,
			"requirement": 8
		}
	],
	[
		{
			"locked": true,
			"requirement": 0
		}
	],
	[
		{
			"locked": true,
			"requirement": 0
		}
	]
]

func _ready():
	if not Engine.editor_hint:
		$AnimationPlayer.play("menu_popup")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func load_fade(): get_viewport().call_deferred("add_child", load("res://interface/Fade.tscn").instance())

# warning-ignore:return_value_discarded
func load_lobby(): get_tree().change_scene("res://room/Lobby.tscn")

func quit_game(): get_tree().quit()

func _process(delta):
	if Engine.editor_hint:
		ProjectSettings.set("object_model_quality", 1)
		ProjectSettings.set("levels", levels)
	else: $Spatial/Camera.rotation_degrees.y -= 2 * delta
