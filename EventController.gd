extends Node
var path = "res://Interactables/"
var dir = Directory.new()
var interactables = []
var rng = RandomNumberGenerator.new()
var player

func _ready():
	player = get_node("/root/Main/Player")
	
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
		pass

func generate_events():
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	if file.ends_with(".tscn"):
		interactables.append(path + file)
	while file:
		file = dir.get_next()
		if file:
			if file.ends_with(".tscn"):
				interactables.append(path + file)
	var choices = []
	for x in range(0, 3):
		rng.randomize()
		var selected = interactables[rng.randi_range(0, interactables.size()-1)]
		choices.append(selected)
		interactables.erase(selected)
	for choice in choices:
		var scene = load(choice).instance()
		add_child(scene)
	display_events()
