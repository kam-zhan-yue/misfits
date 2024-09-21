class_name TutorialPopup
extends Control

const TAGS = "[shake rate=50.0 level=5 connected=1][center]"

const TUTORIALS = {
	"INTRO" : "what's better than one little guy?",
	"COIN" : "like, a hundred of them.",
}

@onready var text := %Text as RichTextLabel

var state: GameState

func init(game_state: GameState) -> void:
	state = game_state
	state.on_tutorial.connect(_on_tutorial)
	state.on_cheese.connect(_on_cheese)

func show_popup() -> void:
	Global.set_active(text)

func hide_popup() -> void:
	Global.set_inactive(text)

func _on_cheese(_value: int) -> void:
	hide_popup()
	
func _on_tutorial(key: String) -> void:
	if key in TUTORIALS:
		show_popup()
		set_text(TUTORIALS[key])
		if key == "COIN":
			state.start()
			await Global.seconds(5.0)
			hide_popup()

func set_text(body: String) ->  void:
	text.text = str(TAGS, body)
