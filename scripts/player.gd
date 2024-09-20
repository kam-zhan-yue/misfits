class_name Player
extends Node2D

func _input(event: InputEvent) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	BoidManager.move(direction)
										
