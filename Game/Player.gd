extends Node
class_name Player

var max_health = 100
var health
var state
const PlayerState = preload("res://Game/PlayerState.gd")
var health_label
var enemy_controller
var Die = load("res://Game/Die.tscn")
var rules
var selected_die
var turns := 0

func _ready():
	health = max_health
	health_label = get_node("/root/Main/Control/Health")
	health_label.text = "HP: {health}/{max}".format({"health":health, "max":max_health})
	state = PlayerState.PLAYER_TURN
	rules = get_node("/root/Main/Rules")
	enemy_controller = get_node("/root/Main/Enemies")
	start_turn()
	display_dice()
	
func _damage_calc(damage):
	if damage > 0:
		health -= damage
		if health <= 0:
			Events.emit_signal("text_log_push", "[shake rate=30 level=10][color=red]Game over![/color][/shake]")
			queue_free()
		Events.emit_signal("text_log_push", "You take [color=red]{damage}[/color] damage.".format({"damage":damage}))
		health_label.text = "HP: {health}/{max}".format({"health":health, "max":max_health})
		
func start_turn():
	yield(get_tree().create_timer(0.25), "timeout")	
	if not enemy_controller.check_victory():
		enemy_controller.generate_chance_numbers()
		turns += 1
		Events.emit_signal("text_log_push", "[wave]=== TURN %s ===[/wave]" % turns)
		state = PlayerState.PLAYER_TURN
		var dice = self.get_children()
		for die in dice:
			die.reset()
		
func start_loot():
	yield(get_tree().create_timer(0.25), "timeout")
	turns = 0
	Events.emit_signal("text_log_push", "[rainbow][wave]Victory![/wave][/rainbow] Select a reward.")
	state = PlayerState.PLAYER_TURN
	var dice = self.get_children()
	for die in dice:
		die.reset()

func _continue():
	yield(get_tree().create_timer(0.25), "timeout")
	if not enemy_controller.check_victory():
		state = PlayerState.PLAYER_TURN	
		if not can_roll():
			enemy_controller.calculate_enemy_attacks()
		else:
			Events.emit_signal("text_log_push", "You can still roll for this turn.")
	
func get_potential_rolls():
	var dice = self.get_children()
	var potential_rolls = []
	for die in dice:
		for side in die.sides:
			if not potential_rolls.has(side):
				potential_rolls.append(side)
	return potential_rolls
	
func get_all_rolls():
	var dice = self.get_children()
	var all_rolls = []
	for die in dice:
		for side in die.sides:
			all_rolls.append(side)
	return all_rolls
	
func can_roll():
	var dice = self.get_children()
	for die in dice:
		if die.times_rolled < rules.roll_limit:
			return true
	return false
	
func select_enemy(enemy):
	if selected_die:
		selected_die.roll(enemy)
		
func display_dice():
	var dice = self.get_children()
	var screen_width = get_viewport().get_visible_rect().size.x
	var increment = screen_width/(dice.size()+1)
	var position = 0
	for die in dice:
		die.get_node("Node2D").position = Vector2(position + increment, 500)
		die.get_node("Node2D").visible = true
		position += increment
		
func hide_dice():
	var dice = self.get_children()
	for die in dice:
		die.get_node("Node2D").visible = false
