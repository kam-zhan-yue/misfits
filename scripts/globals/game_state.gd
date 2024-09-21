class_name GameState
extends Node

var player: Player
var root: Node2D
var cheeses := 0
var spawnable := 0
var in_tutorial := false

signal on_cheese(int)
signal on_power_up(int)
signal on_start
signal on_start_tutorial
signal on_tutorial(String)

var seen: Array[String] = []

func _init(p: Player = null, r: Node2D = null) -> void:
	player = p
	root = r
	cheeses = 0

func tutorial() -> void:
	in_tutorial = true
	on_start_tutorial.emit()

func start() -> void:
	in_tutorial = false
	on_start.emit()

func get_cheese() -> void:
	cheeses += 1
	on_cheese.emit(cheeses)
	trigger_tutorial("CHEESE")

func add_power_up(value: int) -> void:
	spawnable += value

func get_power_up(value: int) -> void:
	spawnable -= value
	on_power_up.emit(value)
	trigger_tutorial("COIN")

func trigger_tutorial(key: String) -> void:
	if key not in seen:
		seen.append(key)
		on_tutorial.emit(key)
