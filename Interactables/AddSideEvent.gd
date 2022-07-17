extends Node

var player

func _ready():
	player = get_node("/root/Main/Player")
	Events.emit_signal("text_log_push", "You may add a side to a die (will always be the next number sequentially after the die's current highest number).")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.selected_die:
			player.selected_die.sides.append(player.selected_die.sides.max()+1)
			player.selected_die.on_sides_update()
			Events.emit_signal("text_log_push", "You added a side to your die!")
			var old_parent = get_parent()
			var new_parent = get_parent().get_parent()
			get_parent().remove_child(self)
			new_parent.add_child(self)
			old_parent.display_events()
			queue_free()
