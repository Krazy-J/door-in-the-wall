extends Control

func _ready():
	# Get saved settings
	if File.new().file_exists("res://DITW-SavedData/settings.json"):
		var settings_file = File.new()
		settings_file.open("res://DITW-SavedData/settings.json", File.READ)
		var settings = parse_json(settings_file.get_line())
		for setting in settings:
			ProjectSettings.set(str(setting), settings[setting])
		settings_file.close()


func _on_popup_hide():
	# Create directory
	# warning-ignore:return_value_discarded
	if not Directory.new().dir_exists("res://DITW-SavedData"): Directory.new().make_dir("res://DITW-SavedData")
	# Gather settings info
	var settings = {
		"object_model_quality":ProjectSettings.object_model_quality,
		"msaa":ProjectSettings.get("rendering/quality/filters/msaa"),
		"shadow_atlas_size":ProjectSettings.get("rendering/quality/shadow_atlas/size"),
		"door_shadow_atlas_size":ProjectSettings.door_shadow_atlas_size,
		"fov":ProjectSettings.fov,
		"mouse_sensitivity":ProjectSettings.mouse_sensitivity
	}
	# Save settings to file
	var settings_file = File.new()
	settings_file.open("res://LITD-SavedData/settings.json", File.WRITE)
	settings_file.store_line(to_json(settings))
	settings_file.close()
