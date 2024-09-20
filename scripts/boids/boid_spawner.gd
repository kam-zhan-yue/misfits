class_name BoidSpawner
extends Node2D

@export var start_x_direction := Vector2.ONE
@export var start_y_direction := Vector2.ONE
@export var spawn_radius := 100.0
@export var spawn_count := 50
@export var spawn_on_ready := true


func _ready() -> void:
	if not spawn_on_ready:
		return
	spawn()

func spawn() -> void:
	spawn_circle()

func spawn_circle() -> void:
	for i in spawn_count:
		var angle := randf() * 2 * PI
		var radius := randf() * spawn_radius
		var spawn_point := Vector2(radius * cos(angle), radius * sin(angle))
		spawn_boid(spawn_point)

func spawn_boid(point: Vector2) -> void:
	var random_x := randf_range(start_x_direction.x, start_x_direction.y)
	var random_y := randf_range(start_y_direction.x, start_y_direction.y)
	var random_direction := Vector2(random_x, random_y)
	var final_pos := global_position + point
	BoidManager.spawn_boid(final_pos, random_direction)
