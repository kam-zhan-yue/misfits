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
@onready var sprite := %Sprite2D as Sprite2D
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

func simulate(input: Vector2) -> void:
	if input == Vector2.ZERO:
		idle()
	else:
		rat(input)
	global_position += velocity * get_process_delta_time()
	update_rotation()

func idle_speed() -> float:
	return BoidManager.SETTINGS.idle_speed

func rat_speed(v: Vector2) -> float:
	return clampf(v.length(), BoidManager.SETTINGS.min_speed, BoidManager.SETTINGS.max_speed)

func idle() -> void:
	var separation_force := steer_towards(separation, true)
	var alignment_force := steer_towards(alignment, true)
	var cohesion_force := steer_towards(cohesion, true)
	var obstacle_force := steer_towards(get_obstacle_force())
	var acceleration := Vector2.ZERO
	acceleration += separation_force * BoidManager.SETTINGS.idle_separation_weight
	acceleration += alignment_force * BoidManager.SETTINGS.alignment_weight
	acceleration += cohesion_force * BoidManager.SETTINGS.idle_cohesion_weight
	acceleration += obstacle_force * BoidManager.SETTINGS.obstacle_weight
	velocity += acceleration * get_process_delta_time()
	velocity = velocity.normalized() * BoidManager.SETTINGS.idle_speed

func rat(input: Vector2) -> void:
	var input_force := steer_towards(input)
	var separation_force := steer_towards(separation)
	var alignment_force := steer_towards(alignment)
	var cohesion_force := steer_towards(cohesion)
	var obstacle_force := steer_towards(get_obstacle_force())
	var acceleration := Vector2.ZERO
	acceleration += input_force * BoidManager.SETTINGS.input_weight
	acceleration += separation_force * BoidManager.SETTINGS.separation_weight
	acceleration += alignment_force * BoidManager.SETTINGS.alignment_weight
	acceleration += cohesion_force * BoidManager.SETTINGS.cohesion_weight
	acceleration += obstacle_force * BoidManager.SETTINGS.obstacle_weight
	velocity += acceleration * get_process_delta_time()
	var final_speed = clampf(velocity.length(), BoidManager.SETTINGS.min_speed, BoidManager.SETTINGS.max_speed)
	velocity = velocity.normalized() * final_speed

func steer_towards(target: Vector2, use_idle: bool = false) -> Vector2:
	if target == Vector2.ZERO:
		return Vector2.ZERO
	var v := target.normalized() * BoidManager.SETTINGS.max_speed - velocity
	if use_idle:
		return v.clampf(-BoidManager.SETTINGS.idle_steer_force, BoidManager.SETTINGS.idle_steer_force)
	else:
		return v.clampf(-BoidManager.SETTINGS.max_steer_force, BoidManager.SETTINGS.max_steer_force)

func update_rotation() -> void:
	var angle = atan2(velocity.y, velocity.x) + 90.0
	if sprite:
		sprite.rotation = angle
		sprite.flip_v = Global.flip_v(angle)

func get_obstacle_force() -> Vector2:
	if not obstacle_view.has_overlapping_areas():
		return Vector2.ZERO
	var overlap := obstacle_view.get_overlapping_areas()
	var obstacle_force := Vector2.ZERO
	for area in overlap:
		var difference := area.global_position - global_position / 100.0
		obstacle_force -= difference.normalized() / pow(difference.length_squared(), 5)
	return obstacle_force

func uninit() -> void:
	BoidManager.uninit(self)
	on_uninit.emit()
