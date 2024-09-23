class_name GameManager
extends Node2D

@onready var player := %Player as Player
@onready var camera_manager := %CameraManager as CameraManager
@onready var cheese_spawner := %CheeseSpawner as CheeseSpawner
@onready var ui := %UI as UI

var game_state: GameState

func _ready() -> void:
	BoidManager.on_erase.connect(_on_erase)
	init_game()
	
func init_game() -> void:
	game_state = GameState.new(player, self)
	game_state.on_start_tutorial.connect(_on_start_tutorial)
	game_state.on_start.connect(_on_start_game)
	game_state.on_restart_game.connect(_on_restart_game)
	cheese_spawner.init(game_state)
	ui.init(game_state)
	Global.on_init.emit(game_state)

func _on_start_tutorial() -> void:
	BoidManager.start()
	game_state.trigger_tutorial("INTRO")
	camera_manager.follow_state()
	camera_manager.zoom_to(5.0)

func _on_start_game() -> void:
	BoidManager.start()
	camera_manager.zoom_to(2)

func _on_cheese(value: int) -> void:
	if value == GameState.CHEESE_PER_ROUND * GameState.ROUNDS:
		# finish game
		pass

func _on_erase(value: int) -> void:
	if value == 0:
		# end game here
		game_state.game_over()
		pass

func _on_restart_game() -> void:
	get_tree().reload_current_scene()
