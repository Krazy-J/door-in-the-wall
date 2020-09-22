tool extends CheckButton

export var settings : PoolStringArray
export var viewport : PoolStringArray
export var os : PoolStringArray

func _ready():
	if settings: pressed = ProjectSettings.get(settings[0])
	elif viewport: pressed = get_viewport().get(viewport[0])
	elif os: pressed = OS.get(os[0])

func _toggled(value):
	for setting in settings: ProjectSettings.set(setting, value)
	for property in viewport: get_viewport().set(property, value)
	for property in os: OS.set(property, value)

func disable(set): disabled = set
func reverse_disable(set): disabled = not set

func _process(_delta):
	_ready()
