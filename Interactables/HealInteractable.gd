extends Node

var player
var rng = RandomNumberGenerator.new()

func _ready():
	player = get_node("/root/Main/Player")
	Events.emit_signal("text_log_push", "You may roll a die to heal you for the amount rolled.")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.selected_die:
			rng.randomize()
			var result = player.selected_die.sides[rng.randi_range(0, player.selected_die.sides.size()-1)]
			player.health += result
			Events.emit_signal("text_log_push", "You healed for {result}.".format({"result":result}))
			var old_parent = get_parent()
			var new_parent = get_parent().get_parent()
			get_parent().remove_child(self)
			new_parent.add_child(self)
			old_parent.display_events()
			queue_free()
