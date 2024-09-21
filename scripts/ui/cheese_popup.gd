class_name CheesePopup
extends Control

const TAGS = "[shake rate=100.0 level=10 connected=1][center]"

const TUTORIALS = {
	"INTRO" : "what's better than one little guy?",
	"COIN" : "like, a hundred of them.",
}

const CHEESE_QUIPS = [
	"Mmmmm, cheeeeeeeessseeeeee",
	"That's some tasty cheese",
	"Oh my god I love cheese so much",
	"That hits the spot",
	"Literally yellow cocaine",
	"Please call 911 I'm trapped under a basement",
]

const RAT_QUIPS = [
	"That's a lot of little guys.",
	"More, more, more, more, more",
	"My wife left me for a rat. I've never been the same since.",
	"How many rats does it take to fix a lightbulb?",
	"Man I wish I was a little guy",
]

@onready var text := %Text as RichTextLabel

const SHOW_TIME = 5.0
var state: GameState
var tween
var timer = 0.0

func init(game_state: GameState) -> void:
	state = game_state
	state.on_cheese.connect(_on_cheese)
	state.on_power_up.connect(_on_power_up)

func _on_cheese(value: int) -> void:
	if state.in_tutorial: return
	var random := randi_range(0, len(CHEESE_QUIPS) - 1)
	show_popup(CHEESE_QUIPS[random])

func _on_power_up(value: int) -> void:
	if state.in_tutorial: return
	var random := randi_range(0, len(RAT_QUIPS) - 1)
	show_popup(RAT_QUIPS[random])

func _process(delta: float) -> void:
	if timer > 0.0:
		timer -= delta
		if timer <= 0.0:
			hide_popup()

func show_popup(body: String) -> void:
	Global.set_active(text)
	text.text = str(TAGS, body)
	timer = SHOW_TIME

func hide_popup() -> void:
	Global.set_inactive(text)
	
