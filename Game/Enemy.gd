extends Node
export var health = 20
var rng = RandomNumberGenerator.new()
var lucky
var curse
var selected_die
signal damage(number)
signal enemy_skipped
signal select(target)
var player
var rules
var parried
var cursed

func _ready():
	parried = false
	player = get_node("/root/Main/Player")
	rules = get_node("/root/Main/Rules")
	connect("damage", player, "_damage_calc")
	connect("enemy_skipped", player, "_continue")	
	connect("select", player, "select_enemy")
	generate_chance_numbers()
	select_die()
	
func _damage_calc(damage):
	if damage == lucky:
		damage += rules.critical
		health -= damage
		Events.emit_signal("text_log_push", "You hit the weak spot for {damage} damage! They have {health} health.".format({"damage":damage, "health":health}))
		parried = true
		Events.emit_signal("text_log_push", "{name} skips their next turn due to your parry".format({"name":name}))
		emit_signal("enemy_skipped")
		clear_chance_numbers()
	elif damage == curse:
		Events.emit_signal("text_log_push", "You have rolled the curse. Your attack is blocked and you receive extra damage from {name}.".format({"name":name}))
		cursed = true
		get_parent().calculate_enemy_attacks()		
	else: 
		health -= damage
		Events.emit_signal("text_log_push", "{name} takes {damage} damage. They have {health} health.".format({"name":name, "damage":damage, "health":health}))
		get_parent().calculate_enemy_attacks()
	get_node("EnemyIcon").on_health_update(health)	

func roll():
	if health <= 0:
		queue_free()
	if parried:
		Events.emit_signal("text_log_push", "{name} skips their turn".format({"name":name}))
		parried = false
	else:
		rng.randomize()
		var result = selected_die.sides[rng.randi_range(0, selected_die.sides.size()-1)]
		Events.emit_signal("text_log_push", "{name} has rolled a {result}.".format({"name":name,"result":result}))
		if cursed:
			result*=2
			cursed = false
		emit_signal("damage", result)
	generate_chance_numbers()
	select_die()
		
func generate_chance_numbers():
	rng.randomize()
	var potential = player.get_potential_rolls()
	lucky = potential[rng.randi_range(0, potential.size()-1)]
	get_node("EnemyIcon").on_lucky_update(lucky)
	potential.erase(lucky)
	rng.randomize()
	curse = potential[rng.randi_range(0, potential.size()-1)]
	get_node("EnemyIcon").on_curse_update(curse)
	
func clear_chance_numbers():
	lucky = -1
	curse = -1
	get_node("EnemyIcon").on_lucky_update("")
	get_node("EnemyIcon").on_curse_update("")	
	
func select_die():
	var dice = self.get_node("Dice").get_children()
	rng.randomize()
	selected_die = dice[rng.randi_range(0,dice.size()-1)]
	Events.emit_signal("text_log_push", "{name} is going to roll their {dice} die next turn.".format({"name":name, "dice":selected_die.sides}))
	
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
		
func _on_Button_pressed():
	emit_signal("select", self)
