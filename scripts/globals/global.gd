extends Node

var zoom := 3.0

func seconds(time: float) -> void:
	await get_tree().create_timer(time).timeout
	
func frame() -> void:
	var delta := get_process_delta_time()
	await get_tree().create_timer(delta).timeout

func set_active(node: Node) -> void:
	active(node, true)
	
func set_inactive(node: Node) -> void:
	active(node, false)

func to_blue() -> Vector2:
	return Vector2(-1.0, 0.5).normalized()

func to_red() -> Vector2:
	return Vector2(1.0, -0.5).normalized()

func active(node: Node, is_active: bool) -> void:
	# Set visibility
	node.visible = is_active
	
	# Set general processing
	node.set_process(is_active)
	
	# Set physics processing
	node.set_physics_process(is_active)
	
	# Optionally, set input processing if needed
	if node.has_method("set_process_input"):
		node.set_process_input(is_active)
	
	# Optionally, set unhandled input processing if needed
	if node.has_method("set_process_unhandled_input"):
		node.set_process_unhandled_input(is_active)

func ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)

func ease_out_sin(x: float) -> float:
	return sin((x * PI) / 2);

func flip_v(rotation: float) -> bool:
	var left_rotate = rotation > -PI*1.5 and rotation <-PI*0.5
	var right_rotate = rotation > PI*0.5 and rotation < PI*1.5
	return left_rotate or right_rotate
