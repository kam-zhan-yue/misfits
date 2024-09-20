extends Node

const SETTINGS = preload("res://resources/boid_settings.tres")

var boids: Array[Boid] = []

func init(boid: Boid) -> void:
	boids.push_back(boid)

func uninit(boid: Boid) -> void:
	boids.erase(boid)

func _process(_delta: float) -> void:
	for boid in boids:
		if boid:
			simulate(boid)

func simulate(boid: Boid) -> void:
	var nearby := get_nearby_boids(boid)
	simulate_forces(boid, nearby)
	boid.simulate()

func get_nearby_boids(boid: Boid) -> Array[Boid]:
	var nearby: Array[Boid] = []
	for b in boids:
		if b == boid:
			continue
		if boid.can_see(b):
			nearby.push_back(b)
	return nearby

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

func restart() -> void:
	for b in boids:
		b.queue_free()
	boids = []
