extends Node

var health = 30
var state
const PlayerState = preload("res://Game/PlayerState.gd")
var Die = load("res://Game/Die.tscn")
var rules
var selected_die

func _ready():
	state = PlayerState.PLAYER_TURN
	rules = get_node("/root/Main/Rules")
	display_dice()
	
func _damage_calc(damage):
	if damage > 0:
		health -= damage
		Events.emit_signal("text_log_push", "You take {damage} damage. You have {health} health.".format({"damage":damage, "health":health}))
		
func start_turn():
	yield(get_tree().create_timer(0.75), "timeout")
	Events.emit_signal("text_log_push", "It is your turn.")
	state = PlayerState.PLAYER_TURN
	var dice = self.get_children()
	for die in dice:
		die.reset()

func _continue():
	yield(get_tree().create_timer(0.75), "timeout")	
	state = PlayerState.PLAYER_TURN	
	if not can_roll():
		start_turn()
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
