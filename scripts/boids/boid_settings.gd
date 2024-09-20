class_name BoidSettings
extends Resource

@export_subgroup("Speed")
@export var min_speed := 70.0
@export var max_speed := 200.0
@export var max_steer_force := 100.0

@export_subgroup("Vision")
@export var vision_radius := 10.0
@export var obstacle_vision_radius := 50.0

@export_subgroup("Weights")
@export var separation_weight := 1.0
@export var alignment_weight := 1.0
@export var cohesion_weight := 1.0
@export var obstacle_weight := 1.0
@export var avoidance_weight := 1.0

@export_subgroup("Flags")
@export var separation := true
@export var alignment := true
@export var cohesion := true
