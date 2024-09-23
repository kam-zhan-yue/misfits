class_name ScorePopup
extends Control

@onready var cheese_1 := $MarginContainer/HBoxContainer/Cheese1 as TextureRect
@onready var cheese_2 := $MarginContainer/HBoxContainer/Cheese2 as TextureRect
@onready var cheese_3 := $MarginContainer/HBoxContainer/Cheese3 as TextureRect

var current = 0

func _ready() -> void:
	Global.on_init.connect(init)
	
func init(game_state: GameState) -> void:
	game_state.on_cheese.connect(_on_cheese)
	
func _on_cheese(value: int) -> void:
	if value % GameState.CHEESE_PER_ROUND == 0:
		turn_on_cheese(value / GameState.CHEESE_PER_ROUND)
	pass

func turn_on_cheese(value: int) -> void:
	if value == 1:
		cheese_1.modulate.a = 1
	elif value == 2:
		cheese_2.modulate.a = 1
	elif value == 3:
		cheese_3.modulate.a = 1
