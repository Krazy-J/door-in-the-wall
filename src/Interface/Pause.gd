extends Popup

func _about_to_show():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _popup_hide():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func quit_level():
	get_viewport().get_child(0).get_node("LobbyDoor").toggle_door()

func quit_menu():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/Main.tscn")
	$"/root".call_deferred("add_child", load("res://src/Interface/Fade.tscn").instance())

func save():
	# Create directory
	# warning-ignore:return_value_discarded
	if not Directory.new().dir_exists("res://DITW-SavedData"): Directory.new().make_dir("res://DITW-SavedData")
	# Save data to file
	var save = File.new()
	save.open("res://save.json", File.WRITE)
	save.store_line(to_json(ProjectSettings.levels))
	save.close()

func save_and_quit():
	save()
	get_tree().quit()

func _unhandled_input(event):
	if event.is_action_pressed("exit_mouse"): popup()
