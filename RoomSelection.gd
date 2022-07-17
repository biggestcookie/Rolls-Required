extends Node

const go_to_room = "res://Interactables/GoToRoom.tscn"
var path = "res://Rooms/Events/"
var dir = Directory.new()
var rooms = []
var rng = RandomNumberGenerator.new()

func _ready():
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	rooms.append(path + file)
	while file:
		file = dir.get_next()
		if file:
			rooms.append(path + file)
	var selected_rooms = []
	for x in range(0, 3):
		rng.randomize()
		var selected_room = rooms[rng.randi_range(0, rooms.size()-1)]
		selected_rooms.append(selected_room)
		rooms.erase(selected_room)
	for room in selected_rooms:
		var scene = load(go_to_room).instance()
		scene.room = room
		add_child(scene)
	display_events()

func display_events():
	var events = self.get_children()
	var screen_width = get_viewport().get_visible_rect().size.x
	var increment = screen_width/(events.size()+1)
	var position = 0
	for event in events:
		event.get_node("Node2D").position = Vector2(position + increment, 325)
		event.get_node("Node2D").visible = true
		position += increment
