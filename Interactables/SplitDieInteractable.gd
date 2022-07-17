extends Node

var player
var rng = RandomNumberGenerator.new()
var Die = load("res://Game/Die.tscn")
var enemy_controller
signal complete

func _ready():
	player = get_node("/root/Main/Player")
	Events.emit_signal("text_log_push", "You may select a die to split (the die must have more than 3 sides and the numbers will be separated randomly).")
	enemy_controller = get_node("/root/Main/Enemies")
	connect("complete", enemy_controller, "generate_enemies")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var can_split = false
		for die in player.get_children():
			if die.sides.size() > 3:
				can_split = true
		if !can_split:
			Events.emit_signal("text_log_push", "You can't split your die. Take 2 damage instead.")
			player.health -= 2
			var old_parent = get_parent()
			var new_parent = get_parent().get_parent()
			get_parent().remove_child(self)
			new_parent.add_child(self)
			old_parent.display_events()
			emit_signal("complete")
			queue_free()
		if player.selected_die:
			var select = player.selected_die
			if select.sides.size() > 3:
				randomize()
				select.sides.shuffle()
				var half = select.sides.size()/2-1
				var first_split = select.sides.slice(0, half)
				var second_split = select.sides.slice(half+1, select.sides.size()-1)
				var first_die = Die.instance()
				first_die.sides = first_split
				player.add_child(first_die)
				var second_die = Die.instance()
				second_die.sides = second_split
				player.add_child(second_die)
				first_die.on_sides_update()
				second_die.on_sides_update()
				select.get_parent().remove_child(select)
				select.queue_free()
				player.display_dice()
				Events.emit_signal("text_log_push", "You split your die!")
				emit_signal("complete")				
				var old_parent = get_parent()
				var new_parent = get_parent().get_parent()
				get_parent().remove_child(self)
				new_parent.add_child(self)
				for child in old_parent.get_children():
					child.queue_free()
				queue_free()
			else:
				Events.emit_signal("text_log_push", "Your die is too small to split.")
				
