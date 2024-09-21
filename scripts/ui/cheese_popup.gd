class_name CheesePopup
extends Control

const TAGS = "[shake rate=100.0 level=10 connected=1][center]"

const TUTORIALS = {
	"INTRO" : "what's better than one little guy?",
	"COIN" : "like, a hundred of them.",
}

const QUIPS = [
	"Mmmmm, cheeeeeeeessseeeeee",
	"That's some tasty cheese",
	"Oh my god I love cheese so much",
	"That hits the spot",
	"Literally yellow cocaine",
	"Please call 911 I'm trapped under a basement",
]

@onready var text := %Text as RichTextLabel

const SHOW_TIME = 5.0
var state: GameState
var tween
var timer = 0.0

func init(game_state: GameState) -> void:
	state = game_state
	state.on_cheese.connect(_on_cheese)

func _on_cheese(value: int) -> void:
	show_popup()

func _process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
		if timer <= 0.0:
			hide_popup()

func show_popup() -> void:
	Global.set_active(text)
	var random := randi_range(0, len(QUIPS) - 1)
	text.text = str(TAGS, QUIPS[random])
	timer = SHOW_TIME

func hide_popup() -> void:
	Global.set_inactive(text)
	
