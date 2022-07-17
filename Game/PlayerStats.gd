extends Node
# class_name PlayerStats

const DieStats := preload("res://Game/DieStats.gd")

export (int) var health := 30 setget on_health_update
var current_dice := []

func _ready():
    current_dice.append_array([
        DieStats.new([1, 2, 3]),
        DieStats.new([4, 5, 6]),
    ])

func on_health_update(new_health: int):
    health = new_health
