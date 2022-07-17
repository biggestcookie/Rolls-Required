extends Control

enum BattleState {
	PLAYER_ACTION,
	GAME_ACTION
}

export (Resource) var combat_scene

const enemy_ui := preload("res://Enemies/EnemyUI.tscn")

var battle_state = BattleState.GAME_ACTION
var current_combat: CombatStats
var current_enemies := []

var selected_enemy_index = null
var selected_dice_index = null


func _ready():
	set_combat(combat_scene)

	var screen_width = get_viewport_rect().size.x

	# Display enemies
	var increment = screen_width/(current_enemies.size() + 1)
	var enemy_position = 0
	for index in range(len(current_enemies)):
		var current_enemy = current_enemies[index]
		var enemy_icon := enemy_ui.instance() as EnemyUI
		current_enemy.enemy_index = index
		enemy_icon.enemy_stats = current_enemy
		enemy_icon.position = Vector2(
			enemy_position + increment,
			350
		)
		add_child(enemy_icon)
		enemy_position += increment

	# Display dice
	# TODO
	start_combat()


func set_combat(new_combat: Resource):
	current_combat = new_combat.instance()
	add_child(current_combat)
	current_enemies = current_combat.enemies


func start_combat():
	var output_str := ""
	output_str = select_enemies_dice()
	EventBus.emit_signal("text_log_push", output_str)
	battle_state = BattleState.PLAYER_ACTION


func select_enemies_dice() -> String:
	var output_str = ""
	for enemy in current_enemies:
		var next_die := (enemy as EnemyStats).select_next_die()
		output_str += "{name} is going to roll their {dice} die next turn.\n".format({
			"name": enemy.name, 
			"dice": next_die.sides
		})
	return output_str
	

# func progress_combat():
