extends Node

const go_to_room = "res://Interactables/GoToRoom.tscn"
var path = "res://Interactables/"
var dir = Directory.new()
var choices = []
var rng = RandomNumberGenerator.new()

func _ready():
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	if file.ends_with(".tscn"):
		choices.append(path + file)
	while file:
		file = dir.get_next()
		if file:
			if file.ends_with(".tscn") and file != "EventInteractable.tscn" and file != "GoToRoom.tscn" and file != "ReturnToRoomSelect.tscn":
				choices.append(path + file)
	var selected_choices = []
	for x in range(0, 2):
		rng.randomize()
		var selected_choice = choices[rng.randi_range(0, choices.size()-1)]
		selected_choices.append(selected_choice)
		choices.erase(selected_choice)
	print(selected_choices)
	for choice in selected_choices:
		var scene = load(choice).instance()
		get_node("EventController").add_child(scene)
	get_node("EventController").display_events()
