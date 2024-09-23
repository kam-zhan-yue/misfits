class_name GameManager
extends Node2D

@onready var player := %Player as Player
@onready var camera_manager := %CameraManager as CameraManager
@onready var cheese_spawner := %CheeseSpawner as CheeseSpawner
@onready var ui := %UI as UI

var game_state: GameState

func _ready() -> void:
	init_game()
	
func init_game() -> void:
	game_state = GameState.new(player, self)
	game_state.on_start_tutorial.connect(_on_start_tutorial)
	game_state.on_start.connect(_on_start_game)
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
	cheese_spawner.start()
	camera_manager.zoom_to(2)
