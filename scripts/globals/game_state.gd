class_name GameState
extends Node

var player: Player
var root: Node2D
var cheeses := 0
var spawnable := 0

signal on_cheese(int)
signal on_power_up(int)
signal on_start
signal on_tutorial(String)

func _init(p: Player = null, r: Node2D = null) -> void:
	player = p
	root = r
	cheeses = 0

func start() -> void:
	on_start.emit()

func get_cheese() -> void:
	cheeses += 1
	on_cheese.emit(cheeses)

func add_power_up(value: int) -> void:
	spawnable += value

func get_power_up(value: int) -> void:
	spawnable -= value
	on_power_up.emit(value)

func trigger_tutorial(key: String) -> void:
	on_tutorial.emit(key)
