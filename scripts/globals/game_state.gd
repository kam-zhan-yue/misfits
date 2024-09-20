class_name GameState
extends Node

var player: Player
var cheeses := 0
var spawnable := 0

signal on_cheese(int)
signal on_power_up(int)

func _init(p: Player = null) -> void:
	player = p
	cheeses = 0

func get_cheese() -> void:
	cheeses += 1
	on_cheese.emit(cheeses)

func add_power_up(value: int) -> void:
	spawnable += value

func get_power_up(value: int) -> void:
	spawnable -= value
	on_power_up.emit(value)
