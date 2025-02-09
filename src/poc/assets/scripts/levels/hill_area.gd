extends Area2D

func _ready():
	body_entered.connect(_on_body_enter)
	body_exited.connect(_on_body_exit)

func _on_body_enter(body):
	if body is Player:
		body.is_hill = true

func _on_body_exit(body):
	if body is Player:
		body.is_hill = false
