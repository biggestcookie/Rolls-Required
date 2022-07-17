extends Node
class_name CombatStats

export(Array, Resource) var enemy_scenes := []
var enemies := []

func _ready(): 
    for enemy_scene in enemy_scenes:
        var enemy = enemy_scene.instance() as EnemyStats
        add_child(enemy)
        enemies.append(enemy)
