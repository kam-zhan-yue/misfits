class_name Cheese
extends Node2D

var state: GameState
var collected := false

func init(game_state: GameState) -> void:
	state = game_state

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if not collected:
		collected = true
		state.get_cheese()
		queue_free()
