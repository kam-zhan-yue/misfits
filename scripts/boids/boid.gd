class_name Boid
extends Node2D

const MAX_STEPS = 36

var velocity := Vector2.ZERO
var direction := Vector2.UP

var separation: Vector2
var alignment: Vector2
var cohesion: Vector2
var obstacle: Vector2
var group: int

@export var using_anim := false
@onready var sprite := %Sprite2D as Sprite2D
var animated_sprite_2d: AnimatedSprite2D
@onready var collect_area := %CollectArea as Area2D

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

func init(boid_group: int) -> void:
	group = boid_group
	#var middle = (BoidManager.SETTINGS.min_speed + BoidManager.SETTINGS.max_speed) * 0.5
	#velocity = middle * direction.normalized()
	BoidManager.init(self)

func simulate(input: Vector2) -> void:
	if input == Vector2.ZERO:
		idle()
	else:
		rat(input)
	global_position += velocity * get_process_delta_time()
	if input != Vector2.ZERO:
		update_rotation()

func idle_speed() -> float:
	return BoidManager.SETTINGS.idle_speed

func rat_speed(v: Vector2) -> float:
	return clampf(v.length(), BoidManager.SETTINGS.min_speed, BoidManager.SETTINGS.max_speed)

func idle() -> void:
	var stabilise_force := steer_towards(-velocity)
	var separation_force := steer_towards(separation, true)
	var alignment_force := steer_towards(alignment, true)
	var cohesion_force := steer_towards(cohesion, true)
	var obstacle_force := steer_towards(get_obstacle_force())
	var acceleration := Vector2.ZERO
	acceleration += stabilise_force
	acceleration += separation_force * BoidManager.SETTINGS.idle_separation_weight
	acceleration += alignment_force * BoidManager.SETTINGS.alignment_weight
	acceleration += cohesion_force * BoidManager.SETTINGS.idle_cohesion_weight
	acceleration += obstacle_force * BoidManager.SETTINGS.obstacle_weight
	velocity += acceleration * get_process_delta_time()
	var final_speed = clampf(velocity.length(), 0, BoidManager.SETTINGS.idle_speed)
	velocity = velocity.normalized() * final_speed

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
	var v = target.normalized() * BoidManager.SETTINGS.max_speed - velocity
	if use_idle:
		return v.clampf(-BoidManager.SETTINGS.idle_steer_force, BoidManager.SETTINGS.idle_steer_force)
	else:
		return v.clampf(-BoidManager.SETTINGS.max_steer_force, BoidManager.SETTINGS.max_steer_force)

func update_rotation() -> void:
	var angle = atan2(velocity.y, velocity.x)
	if sprite:
		sprite.rotation = angle + PI * 0.5

func get_obstacle_force() -> Vector2:
	var space_state := get_world_2d().direct_space_state
	var shape_rid := PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape_rid, BoidManager.SETTINGS.obstacle_vision_radius)
	var params := PhysicsShapeQueryParameters2D.new()
	params.collision_mask = pow(2, 1-1)
	params.shape_rid = shape_rid
	params.transform = get_global_transform()
	var rest_info := space_state.get_rest_info(params)
	if rest_info:
		#print(rest_info.collider_id)
		#print(instance_from_id(rest_info.collider_id))
		return rest_info.normal
	
	# Release the shape when done with physics queries.
	PhysicsServer2D.free_rid(shape_rid)
	
	return Vector2.ZERO

func uninit() -> void:
	BoidManager.uninit(self)
	on_uninit.emit()
