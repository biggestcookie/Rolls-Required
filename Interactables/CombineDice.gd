extends Node

var player
var first_selected
var enemy_controller
signal complete
onready var area2d: Area2D = $Node2D/Area2D
onready var sprite: Sprite = $Node2D/Sprite

func _ready():
	player = get_node("/root/Main/Player")
	Events.emit_signal("text_log_push", "You may select 2 dice to combine.")
	enemy_controller = get_node("/root/Main/Enemies")
	connect("complete", enemy_controller, "generate_enemies")
	connect("complete", player, "start_turn")
	area2d.connect("mouse_entered", self, "on_hover_entered")
	area2d.connect("mouse_exited", self, "on_hover_exited")
	
func _exit_tree():
	area2d.disconnect("mouse_entered", self, "on_mouse_entered")
	area2d.disconnect("mouse_exited", self, "on_mouse_exited")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if player.selected_die:
			var select = player.selected_die
			if not first_selected:
				if first_selected != select:
					first_selected = select
			else:
				for side in select.sides:
					first_selected.sides.append(side)
				first_selected.on_sides_update()
				select.get_parent().remove_child(select)
				select = null
				player.display_dice()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
				Events.emit_signal("text_log_push", "You combined your dice!")
				emit_signal("complete")				
				var old_parent = get_parent()
				var new_parent = get_parent().get_parent()
				get_parent().remove_child(self)	
				new_parent.add_child(self)
				for child in old_parent.get_children():
					child.queue_free()
				queue_free()

func on_hover_entered():
	if player.selected_die:
		sprite.modulate = Color("#A7F0FF")

func on_hover_exited():
	if player.selected_die:
		sprite.modulate = Color("#ffffff")
