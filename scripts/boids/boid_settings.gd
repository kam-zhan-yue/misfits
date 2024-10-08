class_name BoidSettings
extends Resource

@export_subgroup("Bounds")
@export var height := 400.0
@export var width := 400.0

@export_subgroup("Idle Settings")
@export var idle_speed := 10.0
@export var idle_separation_weight := 5.0
@export var idle_cohesion_weight := 5.0
@export var idle_steer_force := 10.0

@export_subgroup("Speed")
@export var min_speed := 70.0
@export var max_speed := 200.0
@export var max_steer_force := 100.0

@export_subgroup("Vision")
@export var vision_radius := 10.0
@export var obstacle_vision_radius := 32.0
@export var separation_radius := 5.0

@export_subgroup("Weights")
@export var input_weight := 1.0
@export var separation_weight := 1.0
@export var alignment_weight := 1.0
@export var cohesion_weight := 1.0
@export var obstacle_weight := 1.0
@export var avoidance_weight := 1.0

@export_subgroup("Flags")
@export var separation := true
@export var alignment := true
@export var cohesion := true
