extends Node
export var max_health = 20
var health
var rng = RandomNumberGenerator.new()
var lucky
var curse
var selected_die
signal damage(number)
signal enemy_skipped
signal select(target)
var player
var parried
var cursed

func _ready():
	health = max_health
	get_node("Node2D").on_health_update(health, max_health)
	parried = false
	player = get_node("/root/Main/Player")
	connect("damage", player, "_damage_calc")
	connect("enemy_skipped", player, "_continue")	
	connect("select", player, "select_enemy")
	generate_chance_numbers()
	select_die()
	
func _damage_calc(damage):
	if damage == lucky:
		damage += 1
		health -= damage
		Events.emit_signal("text_log_push", "You hit the weak spot for [wave][color=yellow]{damage}[/color] damage![/wave] ".format({"damage":damage}))
		if health <= 0:
			get_parent().calculate_enemy_attacks()		
			queue_free()
		parried = true
		Events.emit_signal("text_log_push", "[b]{name}[/b] [rainbow]skips their next turn[/rainbow] due to your parry".format({"name":name}))
		emit_signal("enemy_skipped")
		clear_chance_numbers()
	elif damage == curse:
		Events.emit_signal("text_log_push", "[color=blue][shake rate=30 level=15]You have rolled the curse.[/shake][/color] Your attack is blocked and you receive [shake rate=30 level=15]extra damage[/shake] from [color=red]{name}[/color].".format({"name":name}))
		cursed = true
		get_parent().calculate_enemy_attacks()
	elif damage == 1:
		health -= damage
		Events.emit_signal("text_log_push", "[b]{name}[/b] takes [color=red]{damage}[/color] damage. [rainbow]You may roll again due to your accuracy.[/rainbow]".format({"name":name, "damage":damage}))
		Events.emit_signal("text_log_push", "The [b]Hedgehog[/b]'s [shake rate=30 level=15]spikes[/shake] hurt you!")
		emit_signal("damage", 1)		
		if health <= 0:
			get_parent().calculate_enemy_attacks()
			queue_free()
		emit_signal("enemy_skipped")
	else: 
		health -= damage
		Events.emit_signal("text_log_push", "[b]{name}[/b] takes [color=red]{damage}[/color] damage. ".format({"name":name, "damage":damage}))
		Events.emit_signal("text_log_push", "The [b]Hedgehog[/b]'s [shake rate=30 level=15]spikes[/shake] hurt you!")			
		get_parent().calculate_enemy_attacks()
	get_node("Node2D").on_health_update(health, max_health)

func roll():
	if parried:
		Events.emit_signal("text_log_push", "[b]{name}[/b] skips their turn".format({"name":name}))
		parried = false
	else:
		rng.randomize()
		var result = selected_die.sides[rng.randi_range(0, selected_die.sides.size()-1)]
		Events.emit_signal("text_log_push", "[b]{name}[/b] has rolled a {result}.".format({"name":name,"result":result}))
		if cursed:
			result*=2
			cursed = false
			Events.emit_signal("text_log_push", "[b]{name}[/b]'s damage [shake rate=30 level=15]doubles[/shake] because of your [color=blue]curse[/color].".format({"name":name}))	
		emit_signal("damage", result)
	generate_chance_numbers()
	select_die()

func generate_chance_numbers():
	rng.randomize()
	var potential = player.get_potential_rolls()
	lucky = potential[rng.randi_range(0, potential.size()-1)]
	get_node("Node2D").on_lucky_update(lucky)
	potential.erase(lucky)
	rng.randomize()
	curse = potential[rng.randi_range(0, potential.size()-1)]
	get_node("Node2D").on_curse_update(curse)
	
func clear_chance_numbers():
	lucky = -1
	curse = -1
	get_node("Node2D").on_lucky_update("")
	get_node("Node2D").on_curse_update("")	
	
func select_die():
	var dice = self.get_node("Dice").get_children()
	rng.randomize()
	selected_die = dice[rng.randi_range(0,dice.size()-1)]
	get_node("Node2D").on_roll_update(selected_die.sides)
		
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("select", self)
		
