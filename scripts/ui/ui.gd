class_name UI
extends Control

var state: GameState
var started := false

@onready var start_popup := %StartPopup as StartPopup
@onready var tutorial_popup := %TutorialPopup as TutorialPopup

func _ready() -> void:
	start_popup.show_popup()
	tutorial_popup.hide_popup()

func init(game_state: GameState) -> void:
	state = game_state
	tutorial_popup.init(state)

func _input(_event: InputEvent) -> void:
	if started: return
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		start_popup.hide_popup()
		state.tutorial()
		started = true
