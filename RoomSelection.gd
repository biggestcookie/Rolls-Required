extends Node

const room = "res://Game/Room.tscn"
var path = "res://Rooms/"
var dir = Directory.new()
var rooms = []

func _ready():
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	rooms.append(path + file)
	while file:
		file = dir.get_next()
		if file:
			rooms.append(path + file)
	var scene = load(room).instance()
	scene.room = rooms[0]
	add_child(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
