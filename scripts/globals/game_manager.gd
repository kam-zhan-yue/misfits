class_name GameManager
extends Node2D

@onready var player := %Player as Player
@onready var cheese_spawner := %CheeseSpawner as CheeseSpawner
@onready var enemy := %Enemy as Enemy
@onready var ui := %UI as UI

var game_state: GameState

func _ready() -> void:
	init_game()
	
func init_game() -> void:
	game_state = GameState.new(player)
	game_state.on_cheese.connect(_on_cheese)
	game_state.on_start.connect(_on_start_game)
	cheese_spawner.init(game_state)
	enemy.init(game_state)
	ui.init(game_state)

func _on_start_game() -> void:
	BoidManager.start()
	cheese_spawner.start()
	
func _on_cheese(cheeses: int) -> void:
	print("Cheeses: ", cheeses)
