extends Node
var health = 30
var rng = RandomNumberGenerator.new()
var weakspot
var selected_die
signal enemy_rolled(damage)
var player
var rules

func _ready():
	player = get_node("/root/Main/Player")
	rules = get_node("/root/Main/Rules")
	connect("enemy_rolled", player, "_start_turn")
	generate_weakspot()
	select_die()

func _start_turn(damage):
	var parried = false
	if damage == weakspot:
		damage += rules.critical
		health -= damage
		Events.emit_signal("text_log_push", "You hit the weak spot for {damage} damage! They have {health} health.".format({"damage":damage, "health":health}))
		parried = true
	else:
		health -= damage
		Events.emit_signal("text_log_push", "Enemy takes {damage} damage. They have {health} health.".format({"damage":damage, "health":health}))
	if health > 0:
		if parried:
			Events.emit_signal("text_log_push", "The enemy skips their next turn due to your parry")
			emit_signal("enemy_rolled", 0)			
		else:
			rng.randomize()
			var result = selected_die.sides[rng.randi_range(0, selected_die.sides.size()-1)]
			Events.emit_signal("text_log_push", "The enemy has rolled a {result}.".format({"result":result}))
			emit_signal("enemy_rolled", result)
			generate_weakspot()
			select_die()
		
func generate_weakspot():
	rng.randomize()
	weakspot = player.get_potential_rolls()[rng.randi_range(0, player.get_potential_rolls().size()-1)]
	Events.emit_signal("text_log_push", "Enemy's weak spot is {weakspot}.".format({"weakspot": weakspot}))
	
func select_die():
	var dice = self.get_children()
	rng.randomize()
	selected_die = dice[rng.randi_range(0,dice.size()-1)]
	Events.emit_signal("text_log_push", "Enemy is going to roll their {dice} die next turn.".format({"dice":selected_die.sides}))
	
func isEven(number):
	if number%2==1:
		return true
	else:
		return false
		
func isOdd(number):
	if number%2==0:
		return true
	else:
		return false
