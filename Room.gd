extends Node

var room

func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	get_tree().change_scene(room)
