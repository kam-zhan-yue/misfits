class_name GameState
extends Node

const ROUNDS = 3
const CHEESE_PER_ROUND = 8
var player: Player
var root: Node2D
var cheeses := 0
var spawnable := 0
var in_tutorial := false
var over := false

signal on_cheese(int)
signal on_power_up(int)
signal on_start
signal on_start_tutorial
signal on_tutorial(String)
signal on_game_over
signal on_game_complete
signal on_restart_game

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
	if cheeses == CHEESE_PER_ROUND * ROUNDS:
		game_complete()

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

func game_over() -> void:
	over = true
	on_game_over.emit()

func game_complete() -> void:
	over = true
	on_game_complete.emit()

func restart_game() -> void:
	on_restart_game.emit()
