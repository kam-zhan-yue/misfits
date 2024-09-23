class_name GameCompletePopup
extends Control

@onready var main := $Main as Control
var showing := false
var state: GameState

func _ready() -> void:
	Global.on_init.connect(init)
	Global.set_inactive(main)
	
func init(game_state: GameState) -> void:
	state = game_state
	state.on_game_complete.connect(show_popup)

func show_popup() -> void:
	showing = true
	Global.set_active(main)

func _input(event: InputEvent) -> void:
	if showing and Input.is_action_just_pressed("restart"):
		showing = false
		state.restart_game()
