class_name Boid
extends Node2D

var velocity := Vector2.ZERO
var direction := Vector2.UP

var separation: Vector2
var alignment: Vector2
var cohesion: Vector2
var obstacle: Vector2
var group: int

@export var using_anim := false
@onready var obstacle_view := %ObstacleArea as Area2D
var sprite: Sprite2D
var animated_sprite_2d: AnimatedSprite2D

signal on_uninit

func _ready() -> void:
	if not using_anim:
		sprite = %Sprite2D as Sprite2D
	else:
		animated_sprite_2d = %AnimatedSprite2D as AnimatedSprite2D
		var frames := animated_sprite_2d.sprite_frames.get_frame_count("default")
		var random_frame := randi() % frames
		animated_sprite_2d.frame = random_frame
		animated_sprite_2d.play("default")

func can_see(other: Boid) -> bool:
	if other.group != group:
		return false
	var difference = (other.global_position - global_position).length()
	return difference <= BoidManager.SETTINGS.vision_radius

func init(boid_group: int) -> void:
	group = boid_group
	var middle := (BoidManager.SETTINGS.min_speed + BoidManager.SETTINGS.max_speed) * 0.5
	velocity = middle * direction.normalized()
	BoidManager.init(self)

func simulate() -> void:
	var separation_force := steer_towards(separation)
	var alignment_force := steer_towards(alignment)
	var cohesion_force := steer_towards(cohesion)
	var obstacle_force := steer_towards(get_obstacle_force())
	var acceleration := Vector2.ZERO
	acceleration += separation_force * BoidManager.SETTINGS.separation_weight
	acceleration += alignment_force * BoidManager.SETTINGS.alignment_weight
	acceleration += cohesion_force * BoidManager.SETTINGS.cohesion_weight
	acceleration += obstacle_force * BoidManager.SETTINGS.obstacle_weight
	# Update the velocity by all forces
	velocity += acceleration * get_process_delta_time()
	
	# Clamp the velocity to a min and max speed
	var final_speed := clampf(velocity.length(), BoidManager.SETTINGS.min_speed, BoidManager.SETTINGS.max_speed)
	velocity = velocity.normalized() * final_speed
	global_position += velocity * get_process_delta_time()
	update_rotation()

func steer_towards(target: Vector2) -> Vector2:
	if target == Vector2.ZERO:
		return Vector2.ZERO
	var v := target.normalized() * BoidManager.SETTINGS.max_speed - velocity
	return v.clampf(-BoidManager.SETTINGS.max_steer_force, BoidManager.SETTINGS.max_steer_force)

func update_rotation() -> void:
	var angle = atan2(velocity.y, velocity.x)
	if sprite:
		sprite.rotation = angle
		sprite.flip_v = Global.flip_v(angle)

func get_obstacle_force() -> Vector2:
	if not obstacle_view.has_overlapping_areas():
		return Vector2.ZERO
	var overlap := obstacle_view.get_overlapping_areas()
	var obstacle_force := Vector2.ZERO
	for area in overlap:
		var difference := area.global_position - global_position
		obstacle_force -= difference.normalized() / difference.length_squared()
	return obstacle_force

func uninit() -> void:
	BoidManager.uninit(self)
	on_uninit.emit()
