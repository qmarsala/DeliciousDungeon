class_name InteractIndicator
extends Area2D

var indicator_enabled: bool = true

@onready var label: Label = $Label

func _ready() -> void:
	body_entered.connect(handle_body_entered)
	body_exited.connect(handle_body_exit)

func handle_body_entered(body: Node2D):
	if not indicator_enabled:
		hide()
		return
	
	if body.is_in_group("Player"):
		show()

func handle_body_exit(body: Node2D):
	if not indicator_enabled:
		hide()
		return
	
	if body.is_in_group("Player"):
		hide()

func enable_indicator():
	indicator_enabled = true

func disable_indicator():
	indicator_enabled = false
	hide()
