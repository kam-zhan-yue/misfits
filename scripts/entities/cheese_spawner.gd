class_name CheeseSpawner
extends Node2D

@export var cheese_scene: PackedScene
@export var coin_scene: PackedScene
@export var spawn_points: Array[Marker2D]

const MAX = 100
var state: GameState
var current := 0

func init(game_state: GameState) -> void:
	state = game_state
	state.on_cheese.connect(_on_cheese)
	state.on_start.connect(_on_start)
	var coin := coin_scene.instantiate() as PowerUp
	add_child(coin)
	coin.global_position = $InitialCoin.global_position
	coin.init(state, 50)

func start() -> void:
	while(true):
		spawn_power_up()
		await Global.seconds(10.0)

func _on_start() -> void:
	spawn_cheese()

func _on_cheese(_value: int) -> void:
	spawn_cheese()

func spawn_cheese() -> void:
	if current >= len(spawn_points):
		current = 0
	var spawn_point := spawn_points[current]
	var cheese := cheese_scene.instantiate() as Cheese
	self.call_deferred("add_child", cheese)
	cheese.global_position = spawn_point.global_position
	cheese.init(state)
	current += 1

func spawn_power_up() -> void:
	if state.spawnable + len(BoidManager.boids) >= MAX:
		return
	var coin := coin_scene.instantiate() as PowerUp
	self.call_deferred("add_child", coin)
	var random_x := randf_range(-BoidManager.SETTINGS.width, BoidManager.SETTINGS.width)
	var random_y := randf_range(-BoidManager.SETTINGS.height, BoidManager.SETTINGS.height)
	coin.global_position = Vector2(random_x, random_y)
	coin.init(state, 10)
