class_name CameraManager
extends Camera2D

var zooming := false

enum State { Idle, Follow }
var state := State.Idle

func _process(_delta: float) -> void:
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
	var in_bounds := true
	var view_rect = Rect2(global_position, get_viewport_rect().size / zoom)
	for b in boids:
		average += b.global_position
		if not in_rect(view_rect, b.global_position):
			in_bounds = false
	var target = average / len(boids)
	position = target
	
	if not zooming:
		if in_bounds:
			if len(boids) <= 10:
				zoom_to(5.0)
			else:
				zoom_to(2.0)
		else:
			zoom_to(1.25)


func in_rect(rect: Rect2, point: Vector2) -> bool:
	if point.x < rect.position.x - rect.size.x * 0.5 or point.x > rect.position.x + rect.size.x * 0.5:
		return false
	if point.y < rect.position.y - rect.size.y * 0.5 or point.y > rect.position.y + rect.size.y * 0.5:
		return false
	return true

func zoom_to(target: float, lerp_time: float = 1.0) -> void:
	zooming = true
	var timer := 0.0
	var original_zoom := zoom
	while timer < lerp_time:
		var t := timer / lerp_time
		var x = lerp(original_zoom.x, target, Global.ease_out_sin(t))
		zoom = Vector2(x, x)
		timer += get_process_delta_time()
		await Global.frame()
	zoom = Vector2(target, target)
	zooming = false
