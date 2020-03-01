extends Node

func _process(_delta):
	if $Front.open == true:
		$Left.locked = true
		$Right.locked = true
	if $Left.open == true:
		$Front.locked = true
		$Right.locked = true
	if $Right.open == true:
		$Left.locked = true
		$Front.locked = true
