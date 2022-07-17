extends Node

var room_select_scene = load("res://RoomSelection.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		var scene = room_select_scene.instance()
		get_parent().add_child(scene)
		queue_free()
