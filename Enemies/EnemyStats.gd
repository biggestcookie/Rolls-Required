extends Node
class_name EnemyStats

const DieStats := preload("res://Game/DieStats.gd")


export (int) var max_health := 20
export (int) var lucky := 6
export (int) var curse := 1
export (Texture) var sprite_tex
export (Array, Array, int) var dice_sides := []

onready var enemy_name := get_tree().current_scene.name
onready var health := max_health

var rng = RandomNumberGenerator.new()
var dice := []
var next_die_index := -1
var enemy_index := -1
var parried := false
var cursed := false

func _ready():
    for die_sides in dice_sides:
        var die := DieStats.new(die_sides)
        dice.append(die)

func select_next_die() -> DieStats:
    rng.randomize()
    next_die_index = rng.randi_range(0, dice.size() - 1)
    return dice[next_die_index]
