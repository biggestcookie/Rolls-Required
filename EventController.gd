extends Node

var room_select = load("res://Interactables/ReturnToRoomSelect.tscn")
var player

func _ready():
	player = get_node("/root/Main/Player")
	display_events()

func display_events():
	if player.selected_die:
		player.selected_die = null
	var events = self.get_children()
	if events.size() > 0:
		var screen_width = get_viewport().get_visible_rect().size.x
		var increment = screen_width/(events.size()+1)
		var position = 0
		for event in events:
			event.get_node("Node2D").position = Vector2(position + increment, 325)
			event.get_node("Node2D").visible = true
			position += increment
	else:
		var scene = room_select.instance()
		add_child(scene)
		display_events()
