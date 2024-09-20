class_name StartPopup
extends Control

func show_popup() -> void:
	Global.set_active(self)

func hide_popup() -> void:
	Global.set_inactive(self)
