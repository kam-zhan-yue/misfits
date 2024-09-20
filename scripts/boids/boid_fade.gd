extends Node2D

@onready var parent := $".." as Boid
@export var using_anim := false
var sprite: Sprite2D
var animated_sprite_2d: AnimatedSprite2D

const FADE_OUT = 1.0

func _ready() -> void:
	parent.on_uninit.connect(release)
	if not using_anim:
		sprite = %Sprite2D as Sprite2D
	else:
		animated_sprite_2d = %AnimatedSprite2D as AnimatedSprite2D

func release() -> void:
	var fade_timer := 0.0
	while fade_timer < FADE_OUT:
		var t := fade_timer / FADE_OUT
		if sprite:
			sprite.modulate.a = 1-t
		elif animated_sprite_2d:
			animated_sprite_2d.modulate.a = 1-t
		fade_timer += get_process_delta_time()
		await Global.frame()
	await Global.seconds(1.0)
	queue_free()
