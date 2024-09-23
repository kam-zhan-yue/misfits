class_name Enemy
extends Node2D

@export var speed := 100.0
@export var vision_range := 100.0
@onready var nav := $NavigationAgent2D as NavigationAgent2D
@onready var sprite := $Sprite2D as Sprite2D

var state: GameState

func _ready():
	Global.on_init.connect(init)
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)

func init(game_state: GameState) -> void:
	state = game_state

func _physics_process(delta: float) -> void:
	if not state: return
	if state.over: return
	
	BoidManager.bound(self)
	
	var nearest := BoidManager.get_nearest(global_position, vision_range)
	if len(nearest) == 0:
		return
	
	var target_pos := nearest[0]
	nav.target_position = target_pos
	var direction := (nav.get_next_path_position() - global_position).normalized()
	global_position += direction * speed * delta
	var angle = atan2(direction.y, direction.x)
	sprite.rotation = angle + PI * 0.5


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Boid:
		(area.get_parent() as Boid).uninit()
