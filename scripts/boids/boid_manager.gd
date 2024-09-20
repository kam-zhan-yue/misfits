extends Node

const SETTINGS = preload("res://resources/boid_settings.tres")
const BOID = preload("res://scenes/boid.tscn")

var boids: Array[Boid] = []

var input: Vector2
var running := false

func start() -> void:
	running = true

func init(boid: Boid) -> void:
	boids.push_back(boid)

func uninit(boid: Boid) -> void:
	boids.erase(boid)

func _process(_delta: float) -> void:
	if not running: return
	for boid in boids:
		if boid:
			simulate(boid)
			bound(boid)

func spawn_boid(position: Vector2, direction: Vector2) -> void:
	var boid := BOID.instantiate() as Boid
	add_child(boid)
	boid.global_position = position
	boid.direction = direction
	boid.init(1)

func simulate(boid: Boid) -> void:
	var nearby := get_nearby_boids(boid)
	simulate_forces(boid, nearby)
	boid.simulate(input)
	
func move(player_input: Vector2) -> void:
	input = player_input

func get_nearby_boids(boid: Boid) -> Array[Boid]:
	var nearby: Array[Boid] = []
	for b in boids:
		if b == boid:
			continue
		if can_see(boid.global_position, b.global_position):
			nearby.push_back(b)
	return nearby


func get_nearest(pos: Vector2, range_check: float) -> Array[Vector2]:
	var nearest: Array[Vector2] = []
	for b in boids:
		var adjusted := get_relative_position(pos, b.global_position)
		var distance := (adjusted - pos).length()
		if distance <= range_check:
			if len(nearest) == 0:
				nearest.append(adjusted)
			elif distance < nearest[0].length():
				nearest[0] = adjusted
	return nearest

func simulate_forces(boid: Boid, nearby: Array[Boid]) -> void:
	if len(nearby) == 0:
		return
	var separation := Vector2.ZERO
	var alignment := Vector2.ZERO
	var total_cohesion := Vector2.ZERO
	for b in nearby:
		if boid == b:
			continue
		separation -= get_separation_force(boid, b)
		alignment += get_alignment_force(b)
		total_cohesion += get_cohesion_force(b)
	var cohesion := readjust_cohesion(total_cohesion, boid.global_position, len(nearby))
	boid.separation = separation if SETTINGS.separation else Vector2.ZERO
	boid.alignment = alignment if SETTINGS.alignment else Vector2.ZERO
	boid.cohesion = cohesion if SETTINGS.cohesion else Vector2.ZERO

func get_separation_force(b1: Boid, b2: Boid) -> Vector2:
	var difference := b2.global_position - b1.global_position
	return difference.normalized() / difference.length_squared()


func get_alignment_force(b2: Boid) -> Vector2:
	return b2.direction


func get_cohesion_force(b2: Boid) -> Vector2:
	return b2.global_position


func readjust_cohesion(total: Vector2, original_pos: Vector2, nearby: int) -> Vector2:
	return (total / nearby) - original_pos

func bound(n: Node2D) -> void:
	var pos := n.global_position
	if pos.x > SETTINGS.width:
		pos.x = -SETTINGS.width
	elif pos.x < -SETTINGS.width:
		pos.x = SETTINGS.width
	
	if pos.y > SETTINGS.height:
		pos.y = -SETTINGS.height
	elif pos.y < -SETTINGS.height:
		pos.y = SETTINGS.height
	n.global_position = pos

func can_see(p1: Vector2, p2: Vector2) -> bool:
	var adjusted := get_relative_position(p1, p2)
	var difference := (adjusted - p2).length()
	return difference <= BoidManager.SETTINGS.vision_radius

func get_relative_position(p1: Vector2, p2: Vector2) -> Vector2:
	var q1 = get_quadrant(p1)
	match q1:
		1:
			return get_closest(p1, p2, quadrant_1(p2))
		2:
			return get_closest(p1, p2, quadrant_2(p2))
		3:
			return get_closest(p1, p2, quadrant_3(p2))
		4:
			return get_closest(p1, p2, quadrant_4(p2))
		_:
			return Vector2.ZERO

# The relative position of p from quadrant 1
func quadrant_1(p: Vector2) -> Vector2:
	var quadrant = get_quadrant(p)
	match quadrant:
		1:
			return p
		2:
			return p + Vector2(-SETTINGS.width * 2, 0.0)
		3:
			return p + Vector2(0.0, -SETTINGS.height * 2)
		4:
			return p + Vector2(-SETTINGS.width * 2, -SETTINGS.height * 2)
		_:
			return Vector2.ZERO


# The relative position of p from quadrant 2
func quadrant_2(p: Vector2) -> Vector2:
	var quadrant = get_quadrant(p)
	match quadrant:
		1:
			return p + Vector2(SETTINGS.width * 2, 0.0)
		2:
			return p
		3:
			return p + Vector2(0.0, -SETTINGS.height * 2)
		4:
			return p + Vector2(SETTINGS.width * 2, -SETTINGS.height * 2)
		_:
			return Vector2.ZERO


# The relative position of p from quadrant 3
func quadrant_3(p: Vector2) -> Vector2:
	var quadrant = get_quadrant(p)
	match quadrant:
		1:
			return p + Vector2(0.0, -SETTINGS.height * 2)
		2:
			return p + Vector2(-SETTINGS.width * 2, SETTINGS.height * 2)
		3:
			return p
		4:
			return p + Vector2(-SETTINGS.width * 2, 0.0)
		_:
			return Vector2.ZERO
			

# The relative position of p from quadrant 3
func quadrant_4(p: Vector2) -> Vector2:
	var quadrant = get_quadrant(p)
	match quadrant:
		1:
			return p + Vector2(SETTINGS.width * 2, SETTINGS.height * 2)
		2:
			return p + Vector2(0.0, SETTINGS.height * 2)
		3:
			return p + Vector2(SETTINGS.width * 2, 0.0)
		4:
			return p
		_:
			return Vector2.ZERO

func get_closest(p1: Vector2, p2: Vector2, p3: Vector2) -> Vector2:
	var distance1 := (p2 - p1).length()
	var distance2 := (p3 - p1).length()
	if distance1 < distance2:
		return p2
	else:
		return p3

func get_quadrant(p: Vector2) -> int:
	var x := p.x
	var y := p.y
	if x <= 0 and y <= 0:
		return 1
	elif x <= 0 and y > 0:
		return 3
	elif x > 0 and y <= 0:
		return 2
	else:
		return 4

func restart() -> void:
	for b in boids:
		b.queue_free()
	boids = []
