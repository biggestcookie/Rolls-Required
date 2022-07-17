extends Node

var player
var event_controller
signal end_turn
signal victory
var round_label

var path = "res://Enemies/data/"
var dir = Directory.new()
var enemies = []
var rng = RandomNumberGenerator.new()
var rounds = 1

func _ready():
	round_label = get_node("/root/Main/Control/Rounds")
	player = get_node("/root/Main/Player")
	event_controller = get_node("/root/Main/EventController")
	connect("end_turn", player, "start_turn")
	connect("victory", event_controller, "generate_events")
	connect("victory", player, "start_loot")
	generate_enemies()

func calculate_enemy_attacks():
	for enemy in get_children():
		enemy.roll()
	yield(get_tree().create_timer(0.25), "timeout")
	if get_children().size() == 0:
		player.selected_die = null
		emit_signal("victory")
	else:
		emit_signal("end_turn")
	
func display_enemies():
	var enemies = self.get_children()
	var screen_width = get_viewport().get_visible_rect().size.x
	var increment = screen_width/(enemies.size()+1)
	var position = 0
	for enemy in enemies:
		enemy.get_node("Node2D").position = Vector2(position + increment, 325)
		enemy.get_node("Node2D").visible = true
		position += increment

func generate_enemies():
	dir.open(path)
	dir.list_dir_begin(true)
	var file = dir.get_next()
	if file.ends_with(".tscn"):
		enemies.append(path + file)
	while file:
		file = dir.get_next()
		if file:
			if file.ends_with(".tscn"):
				enemies.append(path + file)
	var choices = []
	for x in range(0, 2):
		rng.randomize()
		var selected = enemies[rng.randi_range(0, enemies.size()-1)]
		choices.append(selected)
		enemies.erase(selected)
	for choice in choices:
		var scene = load(choice).instance()
		add_child(scene)
	Events.emit_signal("text_log_push", "A {first} and {second} approach to fight!".format({"first":get_children()[0].name,"second":get_children()[1].name}))
	round_label.text = "Round {num}".format({"num":rounds})
	rounds+=1
	display_enemies()
