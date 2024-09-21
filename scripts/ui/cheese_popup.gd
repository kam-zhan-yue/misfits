class_name CheesePopup
extends Control

const TAGS = "[shake rate=50.0 level=5 connected=1][center]"

const TUTORIALS = {
	"INTRO" : "what's better than one little guy?",
	"COIN" : "like, a hundred of them.",
}

const QUIPS = [
	"Mmmmm, cheese",
	"That's some tasty cheese",
	"Oh my god I love cheese so much",
	"That hits the spot",
]

@onready var text := %Text as RichTextLabel

var state: GameState
var tween

func init(game_state: GameState) -> void:
	state = game_state
	state.on_cheese.connect(_on_cheese)

func _on_cheese(value: int) -> void:
	if tween:
		tween.kill() # Abort the previous animation.
	print('cheese tween')
	var tween = get_tree().create_tween()
	tween.tween_callback(show_popup)
	tween.tween_interval(5.0)
	tween.tween_callback(hide_popup)

func show_popup() -> void:
	Global.set_active(text)
	var random := randi_range(0, len(QUIPS) - 1)
	text.text = str(TAGS, QUIPS[random])

func hide_popup() -> void:
	Global.set_inactive(text)
	
