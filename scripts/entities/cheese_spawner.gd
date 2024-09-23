class_name CheeseSpawner
extends Node2D

@export var cheese_scene: PackedScene
@export var coin_scene: PackedScene
@export var spawn_points: Array[Marker2D]
@onready var power_up := $PowerUp as Marker2D

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

func _on_start() -> void:
	spawn_cheese()

func _on_cheese(_value: int) -> void:
	spawn_cheese()

func spawn_cheese() -> void:
	if current >= len(spawn_points):
		current = 0
		spawn_power_up()
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
	coin.global_position = power_up.global_position
	coin.init(state, 50)
