tool extends Node

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
			"scene": "Classic/1"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/2"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/_3Loop"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/_6Locked"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/_5Memory"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/_8BuildUp"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/_4ManyDoors"
		},
		{
			"completed": false,
			"locked": true,
			"scene": "Classic/_7Flipped"
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
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed():
	add_child(load("res://src/Interface/Fade.tscn").instance())
	$Fade/AnimationPlayer.play("fade_out")
	$FadeDelay.start()

func _on_fade_timeout():
	get_viewport().call_deferred("add_child", load("res://src/Interface/Fade.tscn").instance())
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/Room/Lobby.tscn")

func quit_game(): get_tree().quit()

func load_game():
	var save = File.new()
	save.open("res://DITW-SavedData/save.json", File.READ)
	var data = []
	data = parse_json(save.get_line())
	ProjectSettings.set("levels", data)
	save.close()
	$Buttons/Load.disabled = true
	$Buttons/Load.text = "Save Loaded"

func save_and_exit_game():
	# Create directory
	# warning-ignore:return_value_discarded
	if not Directory.new().dir_exists("res://DITW-SavedData"): Directory.new().make_dir("res://DITW-SavedData")
	# Save data to file
	var save = File.new()
	save.open("res://DITW-SavedData/save.json", File.WRITE)
	save.store_line(to_json(ProjectSettings.levels))
	save.close()
	get_tree().quit()

func _process(delta):
	if Engine.editor_hint:
		ProjectSettings.set("levels", levels)
	else: $Spatial/Camera.rotation_degrees.y -= 2 * delta
