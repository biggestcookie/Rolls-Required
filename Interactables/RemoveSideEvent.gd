extends Node

var player
var enemy_controller
signal complete
onready var area2d: Area2D = $Node2D/Area2D
onready var sprite: Sprite = $Node2D/Sprite

func _ready():
	player = get_node("/root/Main/Player")
	Events.emit_signal("text_log_push", "You may remove a side from a die (must have more than 2 sides and will always take away the largest number).")
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
		if player and player.selected_die:
			if player and player.selected_die.sides.size() > 2:
				player.selected_die.sides.erase(player.selected_die.sides.max())
				player.selected_die.on_sides_update()
				player.selected_die.reset()
				Events.emit_signal("text_log_push", "You removed a side to your die!")
				emit_signal("complete")				
				var old_parent = get_parent()
				var new_parent = get_parent().get_parent()
				get_parent().remove_child(self)
				new_parent.add_child(self)
				for child in old_parent.get_children():
					child.queue_free()
				queue_free()
			else:
				Events.emit_signal("text_log_push", "This die is not large enough to remove any sides!")

func on_hover_entered():
	if player and player.selected_die:
		sprite.modulate = Color("#A7F0FF")

func on_hover_exited():
	if player and player.selected_die:
		sprite.modulate = Color("#ffffff")
