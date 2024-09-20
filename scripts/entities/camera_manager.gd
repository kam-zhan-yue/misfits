class_name CameraManager
extends Camera2D

@export var lerp_speed := 0.05

enum State { Idle, Follow }
var state := State.Idle

func _process(delta: float) -> void:
	match state:
		State.Follow:
			follow()

func idle_state() -> void:
	state = State.Idle

func follow_state() -> void:
	state = State.Follow

func follow() -> void:
	var boids := BoidManager.boids
	var average := Vector2.ZERO
	for b in boids:
		average += b.global_position
	var target = average / len(boids)
	global_position = lerp(global_position, target, lerp_speed)

func zoom_to(target: float, lerp_time: float = 1.0) -> void:
	var timer := 0.0
	var original_zoom := zoom
	while timer < lerp_time:
		var t := timer / lerp_time
		var x = lerp(original_zoom.x, target, Global.ease_out_sin(t))
		zoom = Vector2(x, x)
		timer += get_process_delta_time()
		await Global.frame()
	zoom = Vector2(target, target)
