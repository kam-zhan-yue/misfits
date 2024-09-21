class_name PowerUp
extends Node

const FADE_IN = 1.0

var state: GameState
var collected := false
var amount: int
var timer := 0.0

@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D

func _process(delta: float) -> void:
	if timer <= FADE_IN:
		timer += delta
		var t := timer / FADE_IN
		animated_sprite_2d.modulate.a = t


func init(game_state: GameState, amount_to_spawn: int) -> void:
	state = game_state
	amount = amount_to_spawn
	state.add_power_up(amount)
	($Spawner as BoidSpawner).spawn_count = amount

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Boid and not collected:
		collected = true
		state.get_power_up(amount)
		spawn()
		queue_free()

func spawn() -> void:
	($Spawner as BoidSpawner).spawn()
