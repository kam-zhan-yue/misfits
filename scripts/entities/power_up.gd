class_name PowerUp
extends Node

@onready var spawner := $Spawner as BoidSpawner

var state: GameState
var collected := false
var amount: int


func init(game_state: GameState, amount_to_spawn: int) -> void:
	state = game_state
	amount = amount_to_spawn
	spawner.spawn_count = amount

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if not collected:
		collected = true
		state.get_power_up(amount)
		spawn()
		queue_free()

func spawn() -> void:
	spawner.spawn()
