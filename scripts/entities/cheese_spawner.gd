class_name CheeseSpawner
extends Node2D

@export var cheese_scene: PackedScene
@export var coin_10_scene: PackedScene

const MAX = 100
var total_rats := 0
var state: GameState

func init(game_state: GameState) -> void:
	state = game_state
	var coin := coin_10_scene.instantiate() as PowerUp
	add_child(coin)
	coin.global_position = $InitialCoin.global_position
	coin.init(state, 100)

func start() -> void:
	while(true):
		spawn_cheese()
		spawn_power_up()
		await Global.seconds(1.0)

func spawn_cheese() -> void:
	var cheese := cheese_scene.instantiate() as Cheese
	add_child(cheese)
	var random_x = randf_range(-BoidManager.SETTINGS.width, BoidManager.SETTINGS.width)
	var random_y = randf_range(-BoidManager.SETTINGS.height, BoidManager.SETTINGS.height)
	cheese.global_position = Vector2(random_x, random_y)
	cheese.init(state)

func spawn_power_up() -> void:
	if state.spawnable + len(BoidManager.boids) >= MAX:
		return
	var coin := coin_10_scene.instantiate() as PowerUp
	add_child(coin)
	var random_x := randf_range(-BoidManager.SETTINGS.width, BoidManager.SETTINGS.width)
	var random_y := randf_range(-BoidManager.SETTINGS.height, BoidManager.SETTINGS.height)
	coin.global_position = Vector2(random_x, random_y)
	coin.init(state, 10)
