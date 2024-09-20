class_name Enemy
extends Node2D

@export var speed := 100.0
@export var range := 500.0
@onready var nav := $NavigationAgent2D as NavigationAgent2D

var state: GameState

func init(game_state: GameState) -> void:
	state = game_state


func _physics_process(delta: float) -> void:
	if not state: return
	
	BoidManager.bound(self)
	
	var nearest := BoidManager.get_nearest(global_position, range)
	if len(nearest) == 0:
		return
	
	var target_pos := nearest[0]
	nav.target_position = target_pos
	var direction := (nav.get_next_path_position() - global_position).normalized()
	global_position += direction * speed * delta
