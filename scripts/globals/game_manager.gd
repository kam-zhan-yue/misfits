class_name GameManager
extends Node2D

@onready var player := %Player as Player
@onready var camera_manager := %CameraManager as CameraManager
@onready var cheese_spawner := %CheeseSpawner as CheeseSpawner

@onready var audio_rats := $AudioRats as AudioStreamPlayer2D
@onready var audio_cheese := $AudioCheese as AudioStreamPlayer2D
@onready var audio_dead := $AudioDead as AudioStreamPlayer2D
@onready var audio_celebration := $AudioCelebration as AudioStreamPlayer2D
@onready var audio_over := $AudioOver as AudioStreamPlayer2D
@onready var bgm := $BGM as AudioStreamPlayer2D

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
	game_state.on_game_complete.connect(_on_game_complete)
	game_state.on_cheese.connect(_on_cheese)
	game_state.on_power_up.connect(_on_power_up)
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

func _on_erase(value: int) -> void:
	audio_dead.play()
	if value == 0:
		# end game here
		bgm.stop()
		audio_over.play()
		game_state.game_over()
		pass

func _on_restart_game() -> void:
	BoidManager.restart()
	get_tree().reload_current_scene()

func _on_game_complete() -> void:
	bgm.stop()
	audio_celebration.play()

func _on_cheese(_value: int) -> void:
	audio_cheese.play()

func _on_power_up(_value: int) -> void:
	audio_rats.play()
