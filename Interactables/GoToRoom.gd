extends Node

var room
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if room:
			for child in get_parent().get_children():
				if child != self:
					child.queue_free()
			var scene = load(room).instance()
			get_parent().add_child(scene)
			queue_free()
