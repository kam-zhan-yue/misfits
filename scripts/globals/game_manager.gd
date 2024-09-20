class_name GameManager
extends Node2D

@onready var player := %Player as Player
@onready var cheese_spawner := %CheeseSpawner as CheeseSpawner
@onready var enemy := %Enemy as Enemy

var game_state: GameState

func _ready() -> void:
	new_game()
	
func new_game() -> void:
	game_state = GameState.new(player)
	game_state.on_cheese.connect(_on_cheese)
	cheese_spawner.init(game_state)
	enemy.init(game_state)
	cheese_spawner.start()
	
func _on_cheese(cheeses: int) -> void:
	print("Cheeses: ", cheeses)
