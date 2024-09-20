class_name GameState
extends Node

var player: Player
var cheeses := 0

signal on_cheese(int)

func _init(p: Player = null) -> void:
	player = p
	cheeses = 0

func get_cheese() -> void:
	cheeses += 1
	on_cheese.emit(cheeses)
