extends Node

var player
var enemy_controller
signal complete

func _ready():
	player = get_node("/root/Main/Player")
	enemy_controller = get_node("/root/Main/Enemies")
	connect("complete", enemy_controller, "generate_enemies")
	Events.emit_signal("text_log_push", "You may add a side to a die (will always be the next number sequentially after the die's current highest number).")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.selected_die:
			player.selected_die.sides.append(player.selected_die.sides.max()+1)
			player.selected_die.on_sides_update()
			player.selected_die.reset()
			Events.emit_signal("text_log_push", "You added a side to your die!")
			var old_parent = get_parent()
			var new_parent = get_parent().get_parent()
			get_parent().remove_child(self)
			new_parent.add_child(self)
			for child in old_parent.get_children():
				child.queue_free()	
			emit_signal("complete")
			queue_free()
